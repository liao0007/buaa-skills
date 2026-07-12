# Report profiles

The `buaa` class is split into **shared core** (`buaa/core/`) and **report profiles**
(`buaa/reports/<name>/`). Each profile defines its own front-matter sequence, metadata
validation (`\checkinput`), running headers, and back-matter commands.

Select a profile with a class option in `chapters/00-meta.md`:

```yaml
classoption:
  - fontset=none          # bundled fonts; prefer over fandol for this template
  - thesis                # or coursework | generic  (default if omitted: thesis)
```

Default when no profile option is given: **`thesis`**.

Root workflow (build script, Pandoc, chapters): [`../../README.md`](../../README.md).

---

## Built-in profiles

| Class option | Folder | Use case | Front matter (order) | Back matter |
|--------------|--------|----------|----------------------|-------------|
| `thesis` | `thesis/` | BUAA graduate thesis (default) | CN cover → EN cover → spine/inner → statement → abstract/keywords → TOC (+ lists) → denotation | `\summary`, `\buaareferences`…`\buaareferencesend`, `\appendix`, `\achievement`, `\acknowledgments`, `\biography`, `\chaptera` |
| `coursework` | `coursework/` | Course / lab report | Cover → abstract → TOC | `\acknowledgments`; other thesis commands are no-ops |
| `generic` | `generic/` | Minimal non-BUAA report | Title page → optional abstract → TOC | Prefer `\Bib{…}{…}`; thesis back-matter commands are no-ops |

Degree options (`master` / `professional` / `doctor` / `prodoctor`), secrecy, and
`library`/`print` are registered globally in `buaa/core/options.tex` but mainly affect
the **thesis** profile (covers, headers, blank verso pages).

---

## Profile anatomy

```
buaa/reports/<profile>/
├── setup.tex              # \input fragments; redefine hooks
├── frontmatter/           # auto-generated before chapter 1
│   └── *.tex              # each file defines one \make... / helper
└── backmatter/            # commands called from Markdown chapters
    └── *.tex
```

### Current trees

**`thesis/`**

```
frontmatter/
  cover-cn.tex      → \makecovercn
  cover-en.tex      → \makecoveren
  cover-inner.tex   → \makecoverinner
  statement.tex     → \makestatementbuaa
  abstract.tex      → \abstructkeyword
  denotation.tex    → \denotation  (symbols / abbreviations)
backmatter/
  summary.tex       → \summary, \buaareferences, \buaareferencesend, \chaptera
  appendix.tex      → \appendix
  achievement.tex   → \achievement
  acknowledgments.tex → \acknowledgments
  biography.tex     → \biography
```

Also loads `buaa/i18n/{buaa-secret,buaa-degree,buaa-departments}.tex` from `setup.tex`.

**`coursework/`**

```
frontmatter/
  cover.tex         → \makecovercourse
  abstract.tex      → \abstructkeyword
backmatter/
  acknowledgments.tex → \acknowledgments (+ no-op \summary/\appendix/…)
```

**`generic/`**

```
frontmatter/
  titlepage.tex     → \makegenerictitle
backmatter/
  stubs.tex         → no-op thesis commands
```

Abstract helper for `generic` is defined inline in `setup.tex` (skips pages if
`\Abstract` was not set).

### Hooks (defined as stubs in `buaa/core/hooks.tex`, overridden in each `setup.tex`)

| Hook | Purpose |
|------|---------|
| `\checkinput` | Validate required `\Title`, `\Author`, … before shipout |
| `\buaa@buildFrontMatter` | Ordered list of cover/abstract/TOC pages |
| `\buaa@setupMainMatterHeaders` | Running headers after front matter |

Lifecycle wiring is in `buaa/core/document.tex`:

- `\AtBeginDocument` → `\checkinput` + PDF hypermeta
- `\AfterEndPreamble` → front-matter page style → `\buaa@buildFrontMatter` → main-matter headers

Shared infrastructure (fonts, fixed geometry, `\Bib`, `\makecontextlist`, metadata
commands) lives in `buaa/core/` and `buaa/font/setup.tex`.

---

## Required metadata by profile

Commands are set in `chapters/00-meta.md` → `header-includes`. Full field tables for
thesis: `chapters/01-导读与配置.md`. Shared command definitions: `buaa/core/metadata.tex`.

### `thesis` (validated by `\checkinput`)

Always: `\Title`, `\Department` (CN + EN), `\Degree`, `\Major`, `\Feild`, `\Tutor`,
`\Author`, `\StudentID`, `\DateEnroll`, `\DateGraduate`, `\DateSubmit`, `\DateDefence`.

If `master` or `doctor`: also `\Discipline`, `\Direction`.

Recommended: `\Abstract`, `\Keyword`; optional `\Listfigtab`, `\Signs`, `\Abbreviations`, …

### `coursework`

Required: `\Title`, `\Author`, `\Course`, `\CourseInstructor`, `\ReportDate`.

Useful: `\Institution`, `\StudentID`, `\Abstract`, `\Keyword`.

### `generic`

Required: `\Title`, `\Author`.

Optional: `\Abstract` / `\Keyword` (omit both to skip abstract pages).

---

## Example: coursework metadata

```yaml
classoption:
  - fontset=none
  - coursework
header-includes:
  - \Course{Corporate Finance}
  - \CourseInstructor{Prof. Zhang}
  - \ReportDate{2026年6月}
  - \Institution{某某大学经济管理学院}
  - \Title{案例分析报告}{Case Study Report}
  - \Author{张三}{Zhang San}
  - \StudentID{20210001}
  - \Abstract{中文摘要…}{}
  - \Keyword{关键词1，关键词2}{}
```

Front matter built: cover → abstract → TOC.  
Back matter: optional `\acknowledgments`. For a BibTeX-style list (non-citeproc), use
`\Bib{style}{bibfile}` from `buaa/core/metadata.tex`. The Markdown + citeproc path used by
this demo (`\buaareferences` + `::: {#refs}`) is **thesis**-specific.

---

## Example: generic metadata

```yaml
classoption:
  - fontset=none
  - generic
header-includes:
  - \Title{技术备忘录}{Technical Memo}
  - \Author{张三}{Zhang San}
  - \Abstract{可选摘要。}{Optional abstract.}
```

---

## Thesis front-matter sequence (detail)

From `thesis/setup.tex` → `\buaa@buildFrontMatter`:

1. `\makecovercn` — Chinese cover  
2. `\makecoveren` — English cover  
3. `\makecoverinner` — spine / inner title  
4. `\makestatementbuaa` — originality / authorization  
5. Switch to numbered front-matter page style  
6. `\abstructkeyword` — bilingual abstract + keywords  
7. `\makecontextlist` — TOC; figure/table lists if `\Listfigtab{on}`  
8. `\denotation` — symbols / abbreviations if provided  

Main-matter headers then use degree-specific 硕/博 running titles.

---

## Adding a new profile

1. Copy `buaa/reports/generic/` to `buaa/reports/my-report/`.
2. Edit `frontmatter/*.tex` and `backmatter/*.tex`.
3. In `setup.tex`, redefine `\checkinput`, `\buaa@buildFrontMatter`, and
   `\buaa@setupMainMatterHeaders`.
4. Register a class option in `buaa/core/options.tex`:

   ```latex
   \DeclareOption{my-report}{\gdef\buaa@report{my-report}}
   ```

5. Rebuild with `classoption: - my-report`.

Loader: `\buaa@loadreport` in `buaa/core/input.tex` inputs
`buaa/reports/<name>/setup.tex`. No changes to `buaa.cls` or existing profiles are
required.

---

## Backward compatibility

Existing thesis projects need **no changes**: the default profile is `thesis`, which
reproduces the original covers, declaration, bilingual abstract, and back-matter commands.
Build entry point is `./buaa/scripts/build.sh` (default output `Artifact.pdf`).
Checked-in PDFs at the thesis root: `输出示例.pdf` (this template) and `官方示例.pdf`
(official reference).
