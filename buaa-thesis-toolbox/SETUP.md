# Environment Setup

End-to-end setup for the Obsidian + Zotero + LaTeX + Pandoc thesis toolchain.
Complete phases in order — Obsidian plugins depend on system-level tools.

Paths below are the verified macOS locations from the reference machine
(Homebrew + MacTeX). Adjust for Windows/Linux where noted.

## Phase 1: System-level prerequisites

- Install **Zotero** desktop.
- Install a **LaTeX** distribution with XeLaTeX + LuaLaTeX:
  - macOS: MacTeX. Windows: MiKTeX or TeX Live. Linux: `texlive-full`.
- Install **Pandoc** ≥ 3.x (Homebrew `brew install pandoc`, or GitHub releases).
- Install an **SVG converter** for TikZ live preview: `pdf2svg` (`brew install
  pdf2svg`) and/or `dvisvgm` (ships with MacTeX/TeX Live).
- Verify on PATH:

  ```bash
  pandoc -v          # expect 3.x
  xelatex -v
  lualatex -v
  ```

  Verified reference paths:
  - `pandoc` → `/opt/homebrew/bin/pandoc`
  - `xelatex` / `pdflatex` / `lualatex` / `dvisvgm` → `/Library/TeX/texbin/…`
  - `pdf2svg` → `/opt/homebrew/bin/pdf2svg`

### Fonts

This template uses **`fontset=none`** and loads bundled fonts from `buaa/font/`
via `buaa/font/setup.tex` (official BUAAThesis 4.1.0 file names):

| Slot | Files under `buaa/font/` |
|------|--------------------------|
| CJK serif 宋体 | `simsun.ttc` |
| CJK sans 黑体 | `simhei.ttf` |
| CJK 楷体 | `simkai.ttf` |
| CJK 仿宋 | `simfang.ttf` |
| Cover 行楷 | `STXingkai.ttf` (`\xingkai`) |
| Latin | `Times New Roman*.ttf` |
| Math | `Cambria Math.ttf` (fallback: STIX Two Math) |

Keep the whole `buaa/font/` directory with the project. Do not rely on
system-installed SimSun alone — the build paths are relative to the thesis root.

If you must replace a file, keep the same filename so `setup.tex` still resolves.

## Phase 2: Zotero & bibliography

- Install **Better BibTeX for Zotero** (`.xpi` from its GitHub releases →
  Zotero `Tools > Add-ons` → gear → `Install Add-on From File`).
- Citation key format: `Zotero Preferences > Better BibTeX` → `auth.lower+year`
  (keys look like `smith2023`).
- Auto-export the bibliography: select the library/collection → right-click →
  `Export Library` → format `Better BibTeX` → enable **Keep updated** → save as
  `<thesis-root>/references.bib`. Confirm it updates after edits.

## Phase 3: Obsidian vault & plugins

- Ensure the thesis-root has `chapters/`, `literatures/`, `buaa/` (from `template/`).
- Restore plugin settings by pointing at the **thesis root** only — the script
  detects vault location, vault-relative thesis path, and external tools:

  ```bash
  SKILL_DIR="$HOME/.cursor/skills/_buaa-skills/buaa-thesis-toolbox"
  "$SKILL_DIR/template-obsidian/restore-obsidian-plugins.sh" "$THESIS_ROOT"
  # optional: add --dry-run to preview detection
  ```

- `Settings > Community Plugins` → turn off Safe Mode → install/enable if missing:
  - **Shell commands** (required) — alias `Build thesis PDF` → `./buaa/scripts/build.sh`
  - **Zotero Integration**, **LuaTikZ**
- Reload Obsidian so `data.json` settings apply.
- PDF builds always go through `./buaa/scripts/build.sh` (system Pandoc + XeLaTeX),
  via Shell commands or a terminal. No Obsidian Pandoc export plugin.

Bundled placeholders live in `template-obsidian/` (see its `README.md`). Restore
merges plugin IDs into `community-plugins.json` and writes **target-specific**
`data.json` (does not keep another author’s folder names or absolute paths;
does not remove unrelated plugins such as Linter / Copilot).

## Phase 4: Plugin configuration

Settings are filled by restore from detection. Verify the printed summary:

### Shell commands (build from Obsidian)

- `working_directory` = detected thesis-rel (`""` if vault == thesis)
- Command: `./buaa/scripts/build.sh` · alias: `Build thesis PDF`
- PATH augmentation for this OS = directories of detected `pandoc` / TeX binaries
  (+ common Homebrew / MacTeX locations when present)
- `execution_notification_mode` = `permanent` (keep the run notification visible
  until dismissed — useful while waiting on XeLaTeX)
- Run via `Cmd/Ctrl+P` → **Build thesis PDF**, or assign a hotkey

### Zotero Integration

- Cite format: Pandoc `[@{{citekey}}]`
- Literature paths: `{thesis-rel}/literatures/…` or `literatures/…` when vault == thesis

Confirm Better BibTeX still auto-exports `<thesis-root>/references.bib`.

Document options stay in `chapters/00-meta.md` (not in any Obsidian plugin):
`fontset=none`, degree, secrecy, `library`/`print`, OS, `short`/`long`,
`STEM`/`HSS`, and report profile (`thesis` / `coursework` / `generic`).

### LuaTikZ (live TikZ preview)

- `lualatexPath` = absolute path from `command -v lualatex` (or probe dirs)
- Preamble includes `luatexja-fontspec` + `Songti SC` for Chinese preview
- Keep the LuaTikZ scratch/temp folder **out of iCloud-synced** plugin dirs if
  the vault syncs through iCloud
- **Fence content:** only `\begin{tikzpicture}…\end{tikzpicture}` (optional
  `\usetikzlibrary{…}`). Never wrap `\begin{figure}` / `\caption` / `\label`
  inside `` ```luatikz `` — that blanks the Obsidian preview. Use `% caption:` /
  `% label:` comments for PDF floats (`tikz.lua`). See AUTHORING.md §Figures — TikZ.
## Phase 5: Pre-flight check

- Math: new note, type `$$ \sum_{i=1}^n $$`, confirm it renders.
- TikZ: open a note with a `luatikz` block, wait 2–3s, confirm SVG in reading mode.
- Zotero bridge: Zotero Integration hotkey (e.g. `Cmd+Shift+O`) → search → import
  → confirm a note appears under `literatures/` with title/abstract/annotations.
- Full build (terminal **or** Obsidian Shell commands → `./buaa/scripts/build.sh`):

  ```bash
  cd <thesis-root>
  ./buaa/scripts/build.sh              # → Artifact.pdf
  ./buaa/scripts/build.sh my-thesis.pdf
  ```

- Spot-check fonts: `pdffonts Artifact.pdf` (expect SimSun / SimHei / Times New Roman / Cambria Math as embedded).

## Completion criteria

- Zotero auto-updates `references.bib`.
- Zotero Integration generates literature notes from your import template.
- Shell commands runs `./buaa/scripts/build.sh` from Obsidian (or the same
  script from a terminal) and produces a PDF with citations resolved
  (superscript) and without missing-font / missing-class errors.
- Math and TikZ render inside Obsidian (if LuaTikZ is installed).
