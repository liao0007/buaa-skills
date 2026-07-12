# Obsidian plugin settings template (BUAA thesis)

Portable settings for the three community plugins used with this thesis workflow.
Does **not** vendor `main.js` / platform binaries — install those from Obsidian’s
Community Plugins list. This template restores **target-aware** `data.json`
configuration via `restore-obsidian-plugins.sh`.

## Plugins

| ID | Name | Role |
|----|------|------|
| `obsidian-shellcommands` | Shell commands | Run `./buaa/scripts/build.sh` (`Build thesis PDF`); default `execution_notification_mode` = `permanent` |
| `obsidian-zotero-desktop-connector` | Zotero Integration | Pandoc citations + literature notes |
| `luatikz` | LuaTikZ | Live TikZ preview |

## What the restore script detects

Point it at the **thesis root** (folder with `buaa/` + `chapters/`). It then:

1. Finds the Obsidian **vault** = nearest ancestor (or self) that already has
   `.obsidian/`, otherwise treats the thesis root as the vault.
2. Computes **thesis-rel** = path of the thesis relative to that vault
   (`""` when they are the same; e.g. `B01.毕业论文` when nested).
3. Locates **pandoc**, **xelatex**, **lualatex** via `PATH` and common install
   dirs (`/opt/homebrew/bin`, `/usr/local/bin`, `/Library/TeX/texbin`, …).
4. Writes plugin settings for *that* layout:
   - Shell commands `working_directory` ← thesis-rel
   - Shell commands PATH augmentation ← detected bin dirs for this OS
   - Zotero literature paths ← `{thesis-rel}/literatures/…` (or `literatures/…`)
   - LuaTikZ `lualatexPath` ← absolute path to detected `lualatex`

Placeholders in shipped `data.json` (`__THESIS_REL__`, `__THESIS_PREFIX__`,
`__LUALATEX_PATH__`, `__BUILD_COMMAND__`) are filled at restore time — they are
not copies of any one author’s machine paths.

## Restore

```bash
SKILL_DIR="$HOME/.cursor/skills/_buaa-skills/buaa-thesis-toolbox"
chmod +x "$SKILL_DIR/template-obsidian/restore-obsidian-plugins.sh"

# Preferred: auto-detect vault + relative path + tools
"$SKILL_DIR/template-obsidian/restore-obsidian-plugins.sh" /path/to/thesis-root

# Preview without writing
"$SKILL_DIR/template-obsidian/restore-obsidian-plugins.sh" /path/to/thesis-root --dry-run

# Rare overrides
"$SKILL_DIR/template-obsidian/restore-obsidian-plugins.sh" /path/to/thesis-root \
  --vault /path/to/vault-root
"$SKILL_DIR/template-obsidian/restore-obsidian-plugins.sh" /path/to/thesis-root \
  --thesis-rel "CustomFolderName"
```

Then in Obsidian: disable Safe Mode → install/enable the three plugins if needed → reload.
