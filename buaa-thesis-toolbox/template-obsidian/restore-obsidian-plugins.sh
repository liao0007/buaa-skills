#!/usr/bin/env bash
# Restore BUAA thesis Obsidian plugin settings into a vault's .obsidian/
#
# Preferred usage (auto-detect vault + relative thesis path + external tools):
#   ./restore-obsidian-plugins.sh /path/to/thesis-root
#
# Optional overrides:
#   ./restore-obsidian-plugins.sh /path/to/thesis-root --vault /path/to/vault
#   ./restore-obsidian-plugins.sh /path/to/thesis-root --thesis-rel "MyThesis"
#   ./restore-obsidian-plugins.sh /path/to/thesis-root --dry-run
#
# Detection:
#   - Vault = nearest ancestor (or self) that contains .obsidian/
#   - Thesis-rel = path of thesis root relative to that vault ("" if same)
#   - pandoc / xelatex / lualatex located via PATH + common install dirs
#   - Shell commands PATH augmentation + LuaTikZ lualatexPath filled from detection
#
# Writes data.json (+ manifest.json) only — install plugin binaries via Obsidian
# Community Plugins if main.js is missing. Merges plugin IDs without removing others.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  cat <<'EOF'
Usage:
  restore-obsidian-plugins.sh <thesis-root> [--vault <vault-root>] [--thesis-rel <rel>] [--dry-run]

Arguments:
  thesis-root   Folder that contains buaa/ and chapters/ (required)

Options:
  --vault       Obsidian vault root (default: auto — nearest ancestor with .obsidian,
                or thesis-root itself if it is / will be the vault)
  --thesis-rel  Override vault-relative path to the thesis (default: auto)
  --dry-run     Print detected layout and tool paths; do not write files
EOF
}

THESIS_ROOT=""
VAULT_OVERRIDE=""
THESIS_REL_OVERRIDE=""
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --vault)
      VAULT_OVERRIDE="${2:-}"
      shift 2
      ;;
    --thesis-rel)
      THESIS_REL_OVERRIDE="${2:-}"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [[ -z "$THESIS_ROOT" ]]; then
        THESIS_ROOT="$1"
        shift
      else
        echo "Unexpected argument: $1" >&2
        usage >&2
        exit 1
      fi
      ;;
  esac
done

if [[ -z "$THESIS_ROOT" ]]; then
  usage >&2
  exit 1
fi

if [[ ! -d "$THESIS_ROOT" ]]; then
  echo "Thesis root does not exist: $THESIS_ROOT" >&2
  exit 1
fi

THESIS_ROOT="$(cd "$THESIS_ROOT" && pwd)"

export SCRIPT_DIR THESIS_ROOT VAULT_OVERRIDE THESIS_REL_OVERRIDE DRY_RUN

python3 <<'PY'
from __future__ import annotations

import json
import os
import platform
import shutil
import sys
from pathlib import Path

SCRIPT_DIR = Path(os.environ["SCRIPT_DIR"])
THESIS_ROOT = Path(os.environ["THESIS_ROOT"]).resolve()
VAULT_OVERRIDE = os.environ.get("VAULT_OVERRIDE") or ""
THESIS_REL_OVERRIDE = os.environ.get("THESIS_REL_OVERRIDE") or ""
DRY_RUN = os.environ.get("DRY_RUN") == "1"

PLUGIN_IDS = (
    "obsidian-shellcommands",
    "obsidian-zotero-desktop-connector",
    "luatikz",
)

CANDIDATE_BIN_DIRS = [
    Path("/opt/homebrew/bin"),
    Path("/usr/local/bin"),
    Path("/Library/TeX/texbin"),
    Path.home() / ".local" / "bin",
    Path.home() / "bin",
]


def die(msg: str, code: int = 1) -> None:
    print(msg, file=sys.stderr)
    raise SystemExit(code)


def looks_like_thesis(root: Path) -> bool:
    return (root / "buaa").is_dir() and (root / "chapters").is_dir()


def find_vault(thesis: Path, override: str) -> Path:
    if override:
        vault = Path(override).expanduser().resolve()
        if not vault.is_dir():
            die(f"--vault is not a directory: {vault}")
        return vault

    # Prefer an existing .obsidian on thesis or an ancestor.
    cur = thesis
    while True:
        if (cur / ".obsidian").is_dir():
            return cur
        if cur.parent == cur:
            break
        cur = cur.parent

    # No vault yet: treat thesis as the vault root (scaffold will create .obsidian).
    return thesis


def rel_posix(from_dir: Path, to_dir: Path) -> str:
    try:
        rel = to_dir.resolve().relative_to(from_dir.resolve())
    except ValueError:
        die(
            f"Thesis root is not inside the vault.\n"
            f"  vault:  {from_dir}\n"
            f"  thesis: {to_dir}"
        )
    return "" if str(rel) == "." else rel.as_posix()


def which_or_probe(name: str) -> Path | None:
    # Do not Path.resolve() — MacTeX's lualatex/xelatex are symlinks to
    # luahbtex/xetex; plugins expect the public command name on PATH.
    found = shutil.which(name)
    if found:
        return Path(found)
    for d in CANDIDATE_BIN_DIRS:
        candidate = d / name
        if candidate.is_file() and os.access(candidate, os.X_OK):
            return candidate
    return None


def platform_key() -> str:
    system = platform.system().lower()
    if system == "darwin":
        return "darwin"
    if system == "windows":
        return "win32"
    return "linux"


def detect_tools() -> dict:
    tools = {
        "pandoc": which_or_probe("pandoc"),
        "xelatex": which_or_probe("xelatex"),
        "lualatex": which_or_probe("lualatex"),
    }
    bin_dirs: list[str] = []
    for path in tools.values():
        if path is None:
            continue
        d = str(path.parent)
        if d not in bin_dirs:
            bin_dirs.append(d)
    # Always include common dirs that exist even if a tool was found elsewhere,
    # so Obsidian's restricted PATH still reaches TeX + Homebrew.
    for d in CANDIDATE_BIN_DIRS:
        if d.is_dir():
            s = str(d)
            if s not in bin_dirs:
                bin_dirs.append(s)
    return {
        "tools": tools,
        "bin_dirs": bin_dirs,
        "path_augment": os.pathsep.join(bin_dirs),
        "platform": platform_key(),
    }


def merge_community_plugins(obsidian: Path) -> list[str]:
    path = obsidian / "community-plugins.json"
    existing: list = []
    if path.exists():
        raw = json.loads(path.read_text(encoding="utf-8"))
        if isinstance(raw, list):
            existing = raw
    merged = list(existing)
    for pid in PLUGIN_IDS:
        if pid not in merged:
            merged.append(pid)
    path.write_text(json.dumps(merged, indent=2) + "\n", encoding="utf-8")
    return merged


def render_plugin_data(
    src: Path,
    *,
    thesis_rel: str,
    thesis_prefix: str,
    lualatex_path: str,
    path_augmentations: dict[str, str],
    build_command: str,
) -> dict:
    text = src.read_text(encoding="utf-8")
    text = text.replace("__THESIS_REL__", thesis_rel)
    text = text.replace("__THESIS_PREFIX__", thesis_prefix)
    text = text.replace("__LUALATEX_PATH__", lualatex_path)
    text = text.replace("__BUILD_COMMAND__", build_command)
    data = json.loads(text)

    # Always overwrite PATH augmentations from live detection (not copied env).
    if "environment_variable_path_augmentations" in data:
        data["environment_variable_path_augmentations"] = path_augmentations

    # Keep shell working_directory synced even if placeholder was missed.
    if "working_directory" in data:
        data["working_directory"] = thesis_rel

    # Shell command body.
    for cmd in data.get("shell_commands") or []:
        platforms = cmd.setdefault("platform_specific_commands", {})
        platforms["default"] = build_command
        if not cmd.get("alias"):
            cmd["alias"] = "Build thesis PDF"

    # LuaTikZ absolute engine path.
    if "lualatexPath" in data:
        data["lualatexPath"] = lualatex_path

    # Zotero vault-relative literature paths.
    for fmt in data.get("exportFormats") or []:
        if "outputPathTemplate" in fmt:
            fmt["outputPathTemplate"] = f"{thesis_prefix}literatures/{{{{citekey}}}}.md"
        if "imageOutputPathTemplate" in fmt:
            fmt["imageOutputPathTemplate"] = f"{thesis_prefix}literatures/{{{{citekey}}}}/"
        if "templatePath" in fmt:
            fmt["templatePath"] = f"{thesis_prefix}literatures/zotero_literature_template.md"

    return data


def main() -> None:
    if not looks_like_thesis(THESIS_ROOT):
        die(
            f"Not a thesis root (need buaa/ and chapters/):\n  {THESIS_ROOT}"
        )

    vault = find_vault(THESIS_ROOT, VAULT_OVERRIDE)
    if THESIS_REL_OVERRIDE:
        thesis_rel = THESIS_REL_OVERRIDE.strip().strip("/").replace("\\", "/")
    else:
        thesis_rel = rel_posix(vault, THESIS_ROOT)

    thesis_prefix = f"{thesis_rel}/" if thesis_rel else ""
    detection = detect_tools()
    tools = detection["tools"]
    lualatex = tools["lualatex"]
    lualatex_path = str(lualatex) if lualatex else "/Library/TeX/texbin/lualatex"

    path_augmentations = {}
    if detection["path_augment"]:
        path_augmentations[detection["platform"]] = detection["path_augment"]

    build_sh = THESIS_ROOT / "buaa" / "scripts" / "build.sh"
    build_command = "./buaa/scripts/build.sh"
    if not build_sh.is_file():
        print(f"WARNING: missing {build_sh}", file=sys.stderr)

    print("Detected layout")
    print(f"  thesis root : {THESIS_ROOT}")
    print(f"  vault root  : {vault}")
    print(f"  thesis-rel  : {thesis_rel or '<vault root>'}")
    print(f"  zotero prefix: {thesis_prefix or '<none>'}")
    print("Detected tools")
    for name, path in tools.items():
        print(f"  {name:8} : {path or 'NOT FOUND'}")
    print(f"  PATH aug[{detection['platform']}]: {detection['path_augment'] or '<empty>'}")
    print(f"  build cmd  : {build_command}")

    missing = [n for n, p in tools.items() if p is None]
    if missing:
        print(
            "WARNING: missing tools "
            + ", ".join(missing)
            + " — install them or fix PATH before building from Obsidian.",
            file=sys.stderr,
        )

    if DRY_RUN:
        print("Dry run — no files written.")
        return

    obsidian = vault / ".obsidian"
    obsidian.mkdir(parents=True, exist_ok=True)
    (obsidian / "plugins").mkdir(parents=True, exist_ok=True)

    merged = merge_community_plugins(obsidian)
    print(
        f"community-plugins.json → {len(merged)} enabled "
        f"({', '.join(PLUGIN_IDS)} ensured)"
    )

    for pid in PLUGIN_IDS:
        src_dir = SCRIPT_DIR / "plugins" / pid
        dst_dir = obsidian / "plugins" / pid
        dst_dir.mkdir(parents=True, exist_ok=True)

        manifest = src_dir / "manifest.json"
        if manifest.is_file():
            (dst_dir / "manifest.json").write_text(
                manifest.read_text(encoding="utf-8"), encoding="utf-8"
            )

        src_data = src_dir / "data.json"
        if not src_data.is_file():
            die(f"Missing template data: {src_data}")

        data = render_plugin_data(
            src_data,
            thesis_rel=thesis_rel,
            thesis_prefix=thesis_prefix,
            lualatex_path=lualatex_path,
            path_augmentations=path_augmentations,
            build_command=build_command,
        )
        dst = dst_dir / "data.json"
        dst.write_text(
            json.dumps(data, indent=2, ensure_ascii=False) + "\n",
            encoding="utf-8",
        )
        print(f"wrote {dst}")

    print()
    print("Restored Obsidian plugin settings into:")
    print(f"  {obsidian}")
    print()
    print("Next in Obsidian:")
    print("  1. Settings → Community plugins → turn off Safe Mode")
    print("  2. Install (if missing) then Enable: Shell commands, Zotero Integration, LuaTikZ")
    print("  3. Reload Obsidian — settings from data.json apply")
    print("  4. Command palette → 'Build thesis PDF'")


if __name__ == "__main__":
    main()
PY
