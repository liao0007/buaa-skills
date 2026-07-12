# BUAA Thesis Typography Reference

Official font/size requirements from 《北京航空航天大学研究生学位论文撰写规范》, plus
template implementation notes for the modular `buaa` project
(`core/` + `reports/` + bundled `font/`).

---

## Official specification (fonts, sizes, weight, spacing)

### 一、封面与题名页

#### 1. 中图分类号、论文编号、密级

- 中文：**黑体五号加粗**
- 数字及英文：**Times New Roman 五号加粗**

#### 2. 论文类别（封面）

- 中文：**华文行楷 48pt**（电子版需作者本人填写）

#### 3. 论文题目（中文封面）

- **32pt 宋体加粗**，居中

#### 4. 作者及指导教师信息（中文封面）

- 中文：**黑体四号**
- 数字及英文：**Times New Roman 四号**

#### 5. 英文封面

- 全部内容：**Times New Roman**
- 论文题目：**小二号加粗**，居中
- 申请学位类型：**四号**，居中
- Candidate 及 Supervisor：**小三号加粗**
- 培养单位英文：**小三号或三号**，居中

#### 6. 题名页

- 中图分类号、论文编号：与封面一致，**五号加粗**（中文黑体，英文/数字 Times New Roman）
- 论文类别（博士/硕士学位论文）：**小二号黑体**，居中，每两字中间空 2 字符
- 论文题目和副题名：**小一号黑体加粗**，居中
- 作者信息及后文表单：从作者姓名起，**小四号宋体**

### 二、独创性声明和使用授权书

| 元素 | 字体要求 |
|------|----------|
| 标题（「关于学位论文的独创性声明」「学位论文使用授权书」） | **三号黑体**，居中 |
| 说明或授权正文 | **小四号宋体** |

### 三、摘要

| 元素 | 字体要求 |
|------|----------|
| 中文摘要标题「摘要」 | **黑体三号加粗**，居中，「摘要」两字间隔 2 字符 |
| 中文摘要正文 | **小四号**；中文 **宋体**，英文 **Times New Roman** |
| 「关键词」三字 | **黑体小四号加粗** |
| 关键词具体内容 | **黑体小四号不加粗** |
| 英文摘要标题「Abstract」 | **Times New Roman 三号加粗**，居中 |
| 英文摘要正文 | **小四号 Times New Roman** |
| 「Keywords」 | **小四号 Times New Roman 加粗** |
| 关键词具体内容（英文） | **小四号 Times New Roman 不加粗** |
| 摘要至主要符号表/缩略语说明的页码 | 大写罗马数字（I、II、III…），**五号 Times New Roman**，居中 |

### 四、目录

| 元素 | 字体要求 |
|------|----------|
| 目录标题「目录」 | **黑体小二号加粗**，居中，两字之间空 2 字符 |
| 章标题行 | **小四号**；中文 **黑体**，英文/数字 **Times New Roman** |
| 一级节标题行 | **小四号**；中文 **宋体**，英文/数字 **Times New Roman** |
| 二级节标题行 | **五号**；中文 **宋体**，英文/数字 **Times New Roman** |
| 前导符和页码 | **小四号** |

### 五、插图、附表清单、主要符号表及缩略语说明

| 元素 | 字体要求 |
|------|----------|
| 标题（「插图清单」「附表清单」等） | **黑体三号**，居中 |
| 内容部分 | **宋体小四号**；英文/数字 **Times New Roman** |

### 六、正文及章节标题

| 元素 | 字体要求 |
|------|----------|
| 各章标题（例：「第一章 引言」） | **三号**，居中；中文 **黑体**，英文/数字 **Times New Roman** |
| 一级节标题（例：「1.1 xxx」） | **四号**，居左；中文 **黑体**，英文/数字 **Times New Roman** |
| 二级节标题（例：「1.1.1 xxx」） | **小四号**，居左；中文 **黑体**，英文/数字 **Times New Roman** |
| 三级节标题（例：「1.1.1.1 xxx」） | **小四号**，居左；中文 **黑体**，英文/数字 **Times New Roman** |
| 正文段落（含附录、研究成果、致谢、作者简介等段落） | **小四号**；中文 **宋体**，英文 **Times New Roman** |
| 页眉（从正文主体开始） | **小五号宋体**，居中；英文/数字 **Times New Roman** |
| 页码（从正文主体开始） | 阿拉伯数字；**Times New Roman 五号**，居中 |

### 七、脚注与参考文献

| 元素 | 字体要求 |
|------|----------|
| 脚注序号（正文处） | **上标**标示于句末（页脚序号字体同正文，非上标） |
| 参考文献指示序号 | **小四号 Times New Roman**，**上角标**，方括号内 |
| 脚注内容（页脚） | **小五号**；中文 **宋体**，英文/数字 **Times New Roman** |
| 「参考文献」标题 | 章标题等级：**三号**，居中；中文 **黑体**，英文/数字 **Times New Roman** |
| 参考文献表正文 | **五号**；中文 **宋体**，英文/数字 **Times New Roman** |

### 八、结尾部分标题

「附录」「攻读博/硕士学位期间取得的研究成果」「致谢」「作者简介」等标题：

- 与**章标题**同级：**三号**，居中；中文 **黑体**，英文/数字 **Times New Roman**
- 内容段落：同正文（**小四号**，中文 **宋体**，英文 **Times New Roman**）

### 九、图、表及表达式

| 元素 | 字体要求 |
|------|----------|
| 图序与图题（图下方） | **五号宋体加粗**，居中；英文/数字 **Times New Roman** |
| 图内文字 | **五号宋体** |
| 图内数字与字母 | **五号 Times New Roman** |
| 分图序与分图题（图下方） | 与图序图题同级（**五号**）；**宋体不加粗** |
| 表序与表题（表上方） | **五号加粗**，居中；中文 **宋体**，英文/数字 **Times New Roman** |
| 表单元格内文字与数字 | **五号**；中文 **宋体**，英文/数字 **Times New Roman** |
| 表下方资料来源 | **小五号**；中文 **宋体**，英文/数字 **Times New Roman** |
| 图表附注 | **五号宋体**；英文/数字 **Times New Roman** |
| 数学表达式 | **Cambria Math 或 Times New Roman**，**小四号** |

### 字号对照（常用）

| 字号 | 约 pt | ctex `\zihao` |
|------|-------|---------------|
| 小二号 | 18pt | `-2` |
| 三号 | 16pt | `3` |
| 四号 | 14pt | `4` |
| 小四号 | 12pt | `-4` |
| 五号 | 10.5pt | `5` |
| 小五号 | 9pt | `-5` |
| 小一号 | 24pt | `-1` |

（规范中直接写 pt 的项，如 32pt、48pt，需用 `\fontsize` 或 ctex 自定义，不能仅靠标准 `\zihao`。）

---

## Template implementation

Build engine: **XeLaTeX** only (`buaa/pandoc.yaml` → `pdf-engine: xelatex`).

Class version string: `\BUAAThesisVer{}` (`v4.1.0 modular` in `buaa/core/packages.tex`).
Compare layout against `官方示例.pdf`; Markdown build sample is `输出示例.pdf`.

### Font files (`buaa/font/setup.tex`)

Aligned with official BUAAThesis 4.1.0 `def/` file names; path is `./buaa/font/`.

| Role | Command / family | File |
|------|------------------|------|
| 宋体 (正文) | `\songti` → `zhsong` | `simsun.ttc` (`AutoFakeBold=4`) |
| 黑体 (标题) | `\heiti` → `zhhei` | `simhei.ttf` |
| 楷体 | `\kaishu` → `zhkai` | `simkai.ttf` |
| 仿宋 | `\fangsong` → `zhfs` | `simfang.ttf` |
| 行楷 (封面类别) | `\xingkai` → `zhxingkai` | `STXingkai.ttf` |
| Latin / 英文 | Times New Roman (main) | `Times New Roman*.ttf` |
| Math | Cambria Math | `Cambria Math.ttf` (fallback STIX Two Math) |

Loaded from `buaa/core/helpers.tex` → `buaa/font/setup.tex`.

**`00-meta.md` must use `fontset=none`** so ctex does not install a competing
font set; the bundled files above are authoritative.

`variables.lmodern: false` in `pandoc.yaml` plus `\AddToHook{package/lmodern/after}`
in `setup.tex` keep Latin on Times New Roman even if Pandoc injects `lmodern`.

### LaTeX mapping cheatsheet

| 规范用语 | Typical implementation |
|----------|------------------------|
| 宋体 | `\songti` / `\CJKfamily{zhsong}` |
| 黑体 | `\heiti` / `\CJKfamily{zhhei}` |
| 华文行楷 | `\xingkai` / `\CJKfamily{zhxingkai}` |
| Times New Roman | main Latin font (`\rmfamily`) |
| 小四号正文 | `\zihao{-4}` + `\songti` (class default via `ctexbook`) |
| 三号章标题 | `\zihao{3}\heiti` — see `buaa/core/layout.tex` `ctexset` |
| 四号节标题 | `\zihao{4}\heiti` |
| 五号图表 | `\zihao{5}\songti` — tables/captions in `layout.tex` |
| 小五号脚注 | `\zihao{-5}\songti` — footnote hooks in core / class |

Chinese + English in one line: CJK via `\songti` / `\heiti`; Latin letters and
digits follow **Times New Roman** via xeCJK auto-switch when `\rmfamily` is active.

### TikZ (PDF build)

- Default inherits document font; for Chinese labels use `font=\rmfamily\small` (Song, not bold).
- Avoid `\songti` in TikZ blocks (breaks Obsidian LuaTikZ preview).
- Avoid `\sffamily` for Chinese (maps to 黑体 / looks bold).
- Spec: figure text **五号宋体**, letters/numbers **五号 Times New Roman**.
- Figures are numbered by chapter. Use bundled `subcaption` for subfigures
  (captions: 五号宋体不加粗).

### Tables (Pandoc pipe tables)

- `buaa/scripts/full-width-tables.lua` — column widths only, **no fonts**.
- `buaa/scripts/longtable-continued.lua` — continuation caption `题注（续）`.
- Fonts from `buaa/core/layout.tex`: body `\songti\zihao{5}`, caption bold 五号.
- Spec: cell text **五号宋体 / Times New Roman**; table title **五号加粗**.

### Where to edit

| Document part | Template location |
|---------------|-------------------|
| Cover, abstract, statement (thesis) | `buaa/reports/thesis/frontmatter/` |
| Thesis back matter commands | `buaa/reports/thesis/backmatter/` |
| Coursework / generic profiles | `buaa/reports/coursework/`, `buaa/reports/generic/` |
| Chapter/section styles, TOC, tables | `buaa/core/layout.tex` |
| Font declarations | `buaa/font/setup.tex` |
| Degree / secrecy / department strings | `buaa/i18n/` |
| Class options | `buaa/core/options.tex` |

### Compliance workflow

1. Identify document part in the official tables above.
2. Locate template code in the matching `reports/<profile>/` fragment or `layout.tex`.
3. Map 字号 → `\zihao{}` or explicit `\fontsize{…}{…}\selectfont` for pt sizes (32pt, 48pt).
4. Rebuild: `./buaa/scripts/build.sh`; spot-check with `pdffonts Artifact.pdf`.
5. Report gaps between spec and current modular `buaa` implementation explicitly.

### Cover Chinese header (`reports/thesis/frontmatter/cover-cn.tex`)

| Element | Implementation |
|---------|----------------|
| 校名 | `buaa/assets/logo-buaa.eps` |
| 论文类别 | `\xingkai\fontsize{48}{58}` (STXingkai) |
| 论文题目 | `\songti\bfseries\fontsize{32}{40}` |

Degree-category strings: `硕士学位论文` / `专业硕士学位论文` / `博士学位论文` /
`专业博士学位论文` (via `buaa/i18n/buaa-degree.tex`).

### Directory TOC (`buaa/core/layout.tex`)

- `tocdepth=2`: chapters, sections, and subsections only.
- Title: bold Heiti 小二, centered, two Chinese-character spaces between `目` and `录`.
- Chapter entries: Heiti 小四.
- Section entries: Song 小四.
- Subsection entries: Song 五号.
- Shared list helper: `\makecontextlist` for TOC / figure / table lists.

### Known template gaps (verify when auditing)

- Cover 32pt / 48pt 行楷 are set with `\fontsize` in `cover-cn.tex`; re-check if
  campus print templates change sizes.
- Math: spec allows Cambria Math or Times New Roman 小四号; this template prefers
  Cambria Math when the TTF is present under `buaa/font/`.
- Profile-specific covers (`coursework` / `generic`) are intentionally lighter
  and are not full BUAA thesis compliance surfaces — use `thesis` for degree submission.
