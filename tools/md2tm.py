#!/usr/bin/env python3
"""Convert the OpenSheaf specification from Markdown to a TeXmacs document.

    tools/md2tm.py [--map FILE.md=FILE.tm ...] input.md output.tm

`--map` turns links to Markdown files that are converted too into links to
their TeXmacs versions (exported to HTML, they become links to the pages).

Handles the subset of Markdown used by spec.md:

- `# Title` (first line): the page title; the first paragraph, if it is in
  *italics*, becomes the abstract. The first line may instead be an image
  `![Title](logo.svg)`, which then stands as the title, or a `<picture>`
  block (light and dark variants, as GitHub shows them), whose logo is the
  hero of the page: centred at about two thirds of the width (0.65), with space around.
  A first line `<!-- site hero: logo.svg -->`, hidden on GitHub, makes that
  logo the hero instead of the image on the next line;
- images `![alt](path)` on a line of their own (centred);
- `## Section`, `### Subsection`, each with a label named as GitHub names
  its anchor (`#what-happens-when-`), for links within and between pages;
- paragraphs; lists with `- ` and nested lists indented by two spaces;
  a paragraph after a nested list is indented by two spaces;
- fenced code blocks (three backticks), with an optional language after
  them (```sh, ```json), used for syntax highlighting on the web;
- inline `code`, **bold**, *italic* and [text](target) links, and
  `<dfn>term</dfn>` for the defining occurrence of a technical term.

The output uses the `notes` style of the author's website with the package
`notes-meta.ts` of this repository. Strings are written for TeXmacs files:
`<`, `>`, `|` and backslashes are escaped, leading and repeated spaces in
code are made explicit, and the file is written in Latin-1 (the
specification is kept in ASCII).
"""

import re
import sys


def esc(t):
    table = {'\\': '\\\\', '<': '\\<less\\>', '>': '\\<gtr\\>', '|': '\\|'}
    return ''.join(table.get(c, c) for c in t)


def emphasis(p):
    p = re.sub(r'\*\*(.+?)\*\*', r'<strong|\1>', p)
    p = re.sub(r'(?<![\w*])\*(?!\s)(.+?)(?<!\s)\*(?![\w*])', r'<em|\1>', p)
    return p


LINK_MAP = {}   # Markdown target -> TeXmacs target (set by --map)


def code_and_emphasis(t):
    out = []
    for i, part in enumerate(re.split(r'`([^`]*)`', t)):
        out.append(f'<verbatim|{esc(part)}>' if i % 2 else terms(part))
    return ''.join(out)


def terms(t):
    # <dfn>term</dfn>, the defining occurrence of a technical term: TeXmacs'
    # dfn tag, exported to HTML as <dfn>
    pieces = re.split(r'<dfn>(.+?)</dfn>', t)
    return ''.join(f'<dfn|{emphasis(esc(p))}>' if i % 2 else emphasis(esc(p))
                   for i, p in enumerate(pieces))


def slug(heading):
    """The anchor GitHub gives a heading: lowercase, punctuation dropped,
    spaces turned into hyphens, so that links to `#anchor` work both on
    GitHub and on the site."""
    t = re.sub(r'\[([^\]]+)\]\([^)]*\)', r'\1', heading).strip().lower()
    t = re.sub(r'[^\w\- ]', '', t)
    return t.replace(' ', '-')


def inline(t):
    # links first: their text may contain `code`
    pieces = re.split(r'\[([^\]]+)\]\(([^)\s]+)\)', t)
    out = []
    for k in range(0, len(pieces), 3):
        out.append(code_and_emphasis(pieces[k]))
        if k + 2 < len(pieces):
            target = pieces[k + 2]
            base, _, anchor = target.partition('#')
            if base in LINK_MAP:
                target = LINK_MAP[base] + ('#' + anchor if anchor else '')
            out.append(f'<hlink|{code_and_emphasis(pieces[k + 1])}|{esc(target)}>')
    return ''.join(out)


def code_line(c):
    if not c.strip():
        return ''
    n = len(c) - len(c.lstrip(' '))
    rest = re.sub(r' {2,}', lambda m: ' ' + '\\ ' * (len(m.group()) - 1),
                  esc(c.lstrip(' ')))
    return '    ' + '\\ ' * n + rest


# languages of fenced code blocks, as named by highlight.js on the web pages
LANGUAGES = {'sh': 'bash', 'shell': 'bash', 'bash': 'bash', 'console': 'bash',
             'json': 'json', 'yaml': 'yaml', 'yml': 'yaml', 'python': 'python',
             'py': 'python', 'xml': 'xml', 'latex': 'latex', 'tex': 'latex'}

SITE_HERO_RE = re.compile(r'^<!--\s*site hero:\s*(\S+)\s*-->\s*$')
IMAGE_RE = re.compile(r'^!\[([^\]]*)\]\(([^)\s]+)\)\s*$')


def image(path, width):
    return f'<image|{esc(path)}|{width}|||>'


def convert(md):
    lines = md.split('\n')
    first = IMAGE_RE.match(lines[0]) if lines else None
    hero = None
    hero_alt = 'OpenSheaf'
    site = SITE_HERO_RE.match(lines[0]) if lines else None
    if site:
        # this logo is the hero, in place of the image (or <picture>) heading
        # the file on GitHub, which is skipped
        hero = image(site.group(1), '0.65par')
        k = 1
        if k < len(lines) and lines[k].strip().startswith('<picture'):
            k = next(m for m in range(k, len(lines)) if '</picture>' in lines[m])
        alt = re.search(r'alt="([^"]*)"', lines[k]) if k < len(lines) else None
        alt = alt or (IMAGE_RE.match(lines[k]) if k < len(lines) else None)
        if alt and alt.group(1):
            hero_alt = alt.group(1)
        lines = [''] + lines[k + 1:]
    elif lines and lines[0].strip().startswith('<picture'):
        # a <picture> (variants for light and dark themes, as on GitHub):
        # its <img> is the hero of the page
        j = next(k for k, ln in enumerate(lines) if '</picture>' in ln)
        block = '\n'.join(lines[:j + 1])
        src = re.search(r'<img[^>]*\ssrc="([^"]+)"', block).group(1)
        alt = re.search(r'<img[^>]*\salt="([^"]*)"', block)
        if alt and alt.group(1):
            hero_alt = alt.group(1)
        hero = image(src, '0.65par')
        lines = [''] + lines[j + 1:]
    elif first:
        # a logo standing for the title
        title_markup = image(first.group(2), '0.5par')
    elif lines and lines[0].startswith('# '):
        title_markup = inline(lines[0][2:].strip())
    else:
        sys.exit('the Markdown file must start with "# Title" or a title image')
    i = 1
    while i < len(lines) and not lines[i].strip():
        i += 1
    abstract = None
    if i < len(lines) and lines[i].startswith('*') and not lines[i].startswith('**'):
        para = []
        while i < len(lines) and lines[i].strip():
            para.append(lines[i].strip())
            i += 1
        text = ' '.join(para)
        abstract = text[1:-1] if text.endswith('*') else text

    blocks = []
    while i < len(lines):
        l = lines[i]
        if not l.strip():
            i += 1
            continue
        if l.startswith('```'):
            # the language after the backticks (```sh, ```json) is passed to
            # the web page as a class of highlight.js (language-bash, ...)
            lang = LANGUAGES.get(l[3:].strip().lower())
            j = i + 1
            code = []
            while j < len(lines) and not lines[j].startswith('```'):
                code.append(lines[j])
                j += 1
            body = '\n\n'.join(code_line(c) for c in code)
            block = '  <\\verbatim-code>\n' + body + '\n  </verbatim-code>'
            if lang:
                block = (f'  <\\html-div-class|language-{lang}>\n' + block
                         + '\n  </html-div-class>')
            blocks.append(block)
            i = j + 1
            continue
        m = IMAGE_RE.match(l)
        if m:
            blocks.append(f'  <\\with|par-mode|center>\n    {image(m.group(2), "0.6par")}\n  </with>')
            i += 1
            continue
        if l.startswith('|') and i + 1 < len(lines) and re.match(r'^\|[\s:|-]+\|\s*$', lines[i + 1]):
            # a Markdown table: a bordered TeXmacs table, header row in bold
            def cells(row):
                return [c.strip() for c in row.strip().strip('|').split('|')]
            rows = [cells(l)]
            i += 2
            while i < len(lines) and lines[i].startswith('|'):
                rows.append(cells(lines[i]))
                i += 1
            # rows, like cells, are separate arguments
            body = '|'.join('<row|' + '|'.join(f'<cell|{inline(c)}>' for c in r) + '>' for r in rows)
            # tformat takes each cell setting as an argument of its own
            blocks.append('  <block|<tformat|<cwith|1|1|1|-1|font-series|bold>|'
                          '<cwith|1|-1|1|-1|cell-valign|top>|'
                          '<cwith|1|-1|1|-1|cell-hyphen|t>|'
                          f'<table|{body}>>>')
            continue
        m = re.match(r'> \[!(WARNING|NOTE|IMPORTANT|CAUTION|TIP)\]\s*$', l)
        if m:
            # GitHub's alert syntax: a box with a label
            kind = m.group(1).lower()
            body = []
            i += 1
            while i < len(lines) and lines[i].startswith('>'):
                body.append(lines[i][1:].strip())
                i += 1
            label = {'warning': 'Warning.', 'note': 'Note.', 'important': 'Important.',
                     'caution': 'Caution.', 'tip': 'Tip.'}[kind]
            blocks.append(f'  <os-alert|{kind}|{label}|{inline(" ".join(body))}>')
            continue
        if l.startswith('### '):
            blocks.append(f'  <subsection*|{inline(l[4:])}><label|{slug(l[4:])}>')
            i += 1
            continue
        if l.startswith('## '):
            blocks.append(f'  <section*|{inline(l[3:])}><label|{slug(l[3:])}>')
            i += 1
            continue
        if l.startswith('- '):
            items = []  # [text, [subitems], text after the sub-list]
            while i < len(lines) and (lines[i].startswith('- ') or lines[i].startswith('  ')):
                ln = lines[i]
                if ln.startswith('- '):
                    items.append([ln[2:], [], ''])
                elif ln.startswith('  - '):
                    items[-1][1].append(ln[4:])
                elif items[-1][1] and ln.startswith('    '):
                    items[-1][1][-1] += ' ' + ln.strip()
                elif items[-1][1]:
                    items[-1][2] += ' ' + ln.strip()
                else:
                    items[-1][0] += ' ' + ln.strip()
                i += 1

            def render(text, subs, after):
                out = '    <item>' + inline(text)
                if subs:
                    out += ('\n\n    <\\itemize>\n'
                            + '\n\n'.join('      <item>' + inline(x) for x in subs)
                            + '\n    </itemize>')
                if after.strip():
                    out += '\n\n    ' + inline(after.strip())
                return out

            body = '\n\n'.join(render(*it) for it in items)
            blocks.append('  <\\itemize>\n' + body + '\n  </itemize>')
            continue
        para = []
        while (i < len(lines) and lines[i].strip()
               and not re.match(r'(#{1,3} |- |```|> |\|)', lines[i])):
            para.append(lines[i].strip())
            i += 1
        blocks.append('  ' + inline(' '.join(para)))

    head = ('<TeXmacs|2.1.5>\n\n<style|<tuple|notes|notes-meta>>\n\n<\\body>\n'
            '  <notes-header>\n\n')
    # the hero: centred, with room above and below, which TeXmacs exports as
    # margins of its paragraph. On the web the page keeps a heading: an <h1>
    # with the hero's text, hidden visually, and the image gets that text as
    # its alternative, for screen readers and search engines.
    if hero:
        t = esc(hero_alt)
        head += (f'  <specific|html*|<html-class|visually-hidden|<html-tag|h:h1|{t}>>>\n\n'
                 f'  <\\center>\n    <vspace*|1fn><html-attr|alt|{t}|{hero}><vspace|2.5fn>\n'
                 '  </center>\n\n')
    else:
        head += f'  <chapter*|{title_markup}>\n\n'
    if abstract:
        head += f'  <notes-abstract|{inline(abstract)}>\n\n'
    tail = ('\n</body>\n\n<\\initial>\n  <\\collection>\n'
            '    <associate|page-medium|paper>\n  </collection>\n</initial>\n')
    return head + '\n\n'.join(blocks) + '\n' + tail


def main():
    args = sys.argv[1:]
    while args and args[0] == '--map':
        src, _, dst = args[1].partition('=')
        LINK_MAP[src] = dst
        args = args[2:]
    if len(args) != 2:
        sys.exit(__doc__)
    sys.argv[1:] = args
    md = open(sys.argv[1], encoding='utf-8').read()
    try:
        md.encode('latin-1')
    except UnicodeEncodeError as e:
        sys.exit(f'{sys.argv[1]}: keep the specification in ASCII ({e})')
    with open(sys.argv[2], 'w', encoding='latin-1', newline='') as f:
        f.write(convert(md))


if __name__ == '__main__':
    main()
