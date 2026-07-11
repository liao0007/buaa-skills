# Report profiles

The `buaa` class is split into **shared core** (`buaa/core/`) and **report profiles**
(`buaa/reports/<name>/`). Each profile defines its own front matter sequence, metadata
validation, headers, and back-matter commands.

## Built-in profiles

| Class option   | Profile folder   | Use case |
|----------------|------------------|----------|
| `buaa-thesis`  | `buaa-thesis/`   | BUAA graduate thesis (default) |
| `coursework`   | `coursework/`    | Course / lab report |
| `generic`      | `generic/`       | Minimal title page + optional abstract + TOC |

Select a profile in Pandoc metadata:

```yaml
classoption:
  - fontset=fandol
  - coursework        # or buaa-thesis (default), generic
```

## Profile anatomy

```
buaa/reports/<profile>/
├── setup.tex              # loads fragments; defines hooks
├── frontmatter/           # auto-generated before chapter 1
│   └── *.tex              # each file defines one \make... command
└── backmatter/            # commands called from Markdown chapters
    └── *.tex              # \summary, \appendix, \acknowledgments, ...
```

### Hooks (defined in `setup.tex`)

| Hook | Purpose |
|------|---------|
| `\checkinput` | Validate required `\Title`, `\Author`, … metadata |
| `\buaa@buildFrontMatter` | Ordered list of cover/abstract/TOC pages |
| `\buaa@setupMainMatterHeaders` | Running headers after front matter |

Shared infrastructure (fonts, layout, `\Bib`, `\makecontextlist`) lives in `buaa/core/`.

## Example: coursework metadata

```yaml
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
Back matter: `\Bib{...}`, optional `\acknowledgments`.

## Adding a new profile

1. Copy `buaa/reports/generic/` to `buaa/reports/my-report/`.
2. Edit `frontmatter/*.tex` and `backmatter/*.tex`.
3. In `setup.tex`, set `\buaa@buildFrontMatter` to call your pages in order.
4. Register a class option in `buaa/core/options.tex`:

   ```latex
   \DeclareOption{my-report}{\gdef\buaa@report{my-report}}
   ```

5. Rebuild with `classoption: - my-report`.

No changes to `buaa.cls` or existing profiles are required.

## Backward compatibility

Existing thesis projects need **no changes**: the default profile is `buaa-thesis`, which
reproduces the original covers, declaration, bilingual abstract, and back-matter commands.
