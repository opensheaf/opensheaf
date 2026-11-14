---
name: opensheaf-style
description: The look and brand of the OpenSheaf site and documents, and the design language shared by every OpenSheaf page on the web (the site, the Explorer, the pages of an archive, the woven literate programs). Use before changing page layout, the hero, typography, colours, the logo or other brand assets, or the build of the pages.
---

# OpenSheaf style

## How the pages are made

- Edit only the Markdown sources: `README.md` (home page and GitHub README),
  `opensheaf-specification-0.1.md`, `FAQ.md`, `USE-CASES.md`.
- `tools/md2tm.py` converts them to TeXmacs; `tools/build.py` runs it and
  exports each `.tm` to `.html`. Never edit the `.tm` or `.html` files; commit
  them regenerated, together with their sources.
- The build needs the `notes` and `max-html` plugins of the author's website
  repository (`mgubi/mgubi.github.io`, `plugins/`), linked in
  `~/.TeXmacs/plugins` or given with `TEXMACS_PLUGINS`. Do not copy them into
  this repository.
- A page made from TeXmacs carries only what TeXmacs exports: no HTML is
  written for the look of the web (no `tmhtml-` macro in `notes-meta.ts`
  that adds elements or classes for the stylesheet). The stylesheet adapts
  to the export, as it does for the header. Markup of its own belongs to
  the Explorer, which is a JavaScript application, and to the templates of
  the other tools.
- Layout belongs to TeXmacs: the converter (hero, spacing) and `notes-meta.ts`
  (the style). `resources/opensheaf.css` only mirrors that look on the web,
  because the HTML export carries no fonts or colours.
- Technical terms: `<dfn>term</dfn>` at their defining occurrence (the
  terminology of the specification, terms introduced in the use cases),
  **bold** for other key uses in running text, `code` for literal names and
  values. The converter turns `<dfn>` into TeXmacs' `dfn` tag, shown in
  italics, as in a mathematical text, and exported as HTML `<dfn>`.
- Alerts (GitHub's `> [!WARNING]`, `> [!NOTE]`): `os-alert` in
  `notes-meta.ts`, drawn by `os-alert-box`, a one-cell table with a 3pt
  rule on its left: the table is set in the colour of the rule (TeXmacs
  borders have no colour of their own) and the content back in the colour
  of the text; on the surface tint, as the `div.os-alert` of the web. Do not use `padded-framed`: TeXmacs 2.1 does not define it.

## The design language

One language for every OpenSheaf page on the web, thought out from the
basics rather than inherited: a page is a sheet of paper, and reads like a
well-set mathematical text.

### Principles

1. **Paper and ink.** A warm white page, black ink, one narrow column,
   generous leading, a lot of air. Space, not rules or boxes, sets things
   apart.
2. **Three voices.** A serif (EB Garamond) for everything that is read:
   text, titles, authors, abstracts, values. A small quiet sans-serif (the
   system's) for the apparatus around it: navigation, labels, tags, table
   headers, dates and facts, controls, footers. A monospace (Source Code
   Pro) for literal names, identifiers and digests.
3. **No colour.** Hierarchy comes from size, space and italics, not from
   weight or hue: headings are in the regular weight of the serif; links
   are in ink with a thin grey underline. Three quiet tones only say a
   state, always with a text label: green for verified or current, red for
   errors and withdrawals, amber for warnings.
4. **Nothing decorative.** Hairlines and faint tints; no frames, shadows,
   gradients, icons or emoji. Corners of 4px on tinted blocks; tags are
   fully rounded.

### Where it lives

Four stylesheets carry it; a change of the language is made in all four,
and here:

| Pages | Stylesheet | Source to edit |
|---|---|---|
| this site | `resources/opensheaf.css` | the file itself |
| the Explorer (`opensheaf/explorer`) | `style.css` | `literate/31-style.md` |
| the default pages of an archive (`opensheaf/opensheaf-py`) | `templates/style.css` | `literate/31-templates.md`; then copied to `archive-template` and `collection-template` (`templates/`, `style.css`) |
| the woven literate programs (`opensheaf/literate`) | `weave.css` | `literate/20-weave.md` |

### The pieces

- **Tokens.** The block of custom properties `--os-*` at the top of
  `resources/opensheaf.css` (light, dark, print) is the same, to the letter,
  in the four stylesheets: copy it whole, never one value. Styles use the
  tokens, not colours of their own.
- **Palette.** Light: paper `#f9f8f5`, surface (tinted blocks) `#f1efea`,
  hairlines `#dedbd3`, ink `#171716`, secondary text `#6a6861`
  (`--os-muted`, 5:1 on the paper), bullets and underlines `#a09d95`
  (`--os-faint`, never for text). Dark: paper `#12141a`, surface `#1b1e25`,
  hairlines `#31353e`, ink `#e6e7ea`, muted `#9a9ea8`, faint `#646975`.
  States: `--os-ok` `#2c6a3e` on `#e6efe4`, `--os-bad` `#9d2b22` on
  `#f6e4e0`, `--os-warn` `#7d5200` on `#f5ecd6` (dark: `#93cfa1` on
  `#182a23`, `#eda59c` on `#342025`, `#e7c277` on `#2d281c`). Print: black
  on white. No other colours.
- **Type.** Text in EB Garamond at 20px (18px in the Explorer and on a
  phone), leading 1.6, lining numerals, in a column of about 36rem (46rem
  in the Explorer, for its tables). Headings in the regular weight: the
  title of a page 2.4 to 2.5rem, tight, centred like the title of a paper,
  with authors (italics) and first facts centred below it; sections
  1.5rem; subsections in italics, a little larger than the text. Bold
  (weight 600) only for run-in labels. A term where it is defined
  (`<dfn>`) in italics.
- **Apparatus.** The sans at 0.6 to 0.76rem, in the muted grey; labels
  above a title and table headers in capitals, letter-spaced.
- **Masthead.** The same on every page: the symbol and the name on the
  left, in the serif; the pages on the right, in the small sans, grey, the
  page being read in ink. No rule below it. An archive's masthead carries
  the archive's name and no OpenSheaf symbol.
- **Links.** In the ink of the text, a 1px underline in the faint grey that
  turns to ink under the pointer; no visited colour. Navigation links are
  not underlined.
- **Abstract.** In italics under the title, without a rule.
- **Notes, warnings, notices, verdicts.** A block on the surface, or on the
  tint of its state, without a frame or a rule; a warning opens with a
  run-in label ("Warning.") in the amber tone.
- **Tags.** Small fully rounded labels in the sans, on the surface or on
  the tint of a state.
- **Tables.** Ruled as in a book: a rule in ink at the head and at the
  foot, hairlines between rows, no vertical rules; the header in the small
  capitals of the apparatus.
- **Code.** Blocks on the surface, without a frame; inline code on the
  same tint. No syntax colours: keywords a little stronger, strings,
  numbers and comments grey.
- **Lists of documents.** Entries divided by hairlines, as in a
  bibliography: the title a little larger than the text, the authors in
  italics, then a line of facts in the small sans.
- **Controls** (the Explorer): in the sans, a hairline border on the
  paper; the one primary button in ink.
- The theme control of this site, one button (a half-lit circle) floating
  at the top right corner of the window, switches between light and dark; a
  visit opens in the default theme, which follows the system, and the choice
  is kept for the browsing session (the tab). The other pages follow the
  system; their tokens also answer to `data-theme`.
- The first paragraph of a page, in *italics* in the Markdown, becomes the
  abstract.
- The masthead of this site is the header of the `notes` style as TeXmacs
  exports it (`notes-header-links` in `notes-meta.ts`: links in brackets,
  also printed in the PDF); `resources/opensheaf.css` hides the brackets
  and sets the first link as the name; `resources/theme.js` marks the page
  being read.
- The PDF follows the same look within TeXmacs: ink and paper of the
  tokens, headings in the regular weight, defined terms in italics
  (`notes-meta.ts`).

## Hero

- Home page: the opening `<picture>` block in `README.md` provides light and
  dark logo variants on GitHub. Its `img` source becomes the site hero at 65%
  of the column (`0.65par`), with `vspace` 4fn above and 5fn below.
- A first-line `<!-- site hero: path -->` comment can instead select a site
  hero that differs from an image on the following line.
- Other pages open with their `# Title`; no images above it.

## Brand assets (`resources/brand/`)

- Logo (mark left, lettering right), symbol (mark only), wordmark (lettering
  only), favicon, PNG and vector PDF of the logo. Their README gives the
  geometry.
- The logo and symbol use black ink; `opensheaf-logo-dark.svg` is the white
  variant and the wordmark uses `currentColor`. On the site, the black logo is
  inverted by `opensheaf.css` in the dark theme.
- Preserve proportions and clear space; do not recolour, outline, stretch or
  re-space the dots or the letters.

## Fonts

- Lettering: outlined from Geist Serif Regular (SIL OFL,
  `GeistSerif-LICENSE.txt`); no font file is loaded for it.
- Web pages: EB Garamond (SIL OFL) for text and headings, two variable
  WOFF2 files in `resources/fonts/garamond/` (their README says how they
  were made), loaded by the site stylesheet; Source Code Pro for code, from
  `resources/fonts/source/`; the system's sans-serif for the apparatus.
  The Explorer keeps copies in its `fonts/` (its content security policy
  takes nothing from elsewhere); the default pages of an archive and the
  woven literate programs load EB Garamond from `opensheaf.org`, and fall
  back on a serif of the system.
- TeXmacs documents and PDF: the fonts of the `notes` style.
- New fonts or images need their licence and credit in the brand README.
