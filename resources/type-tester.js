/* A type tester for the site: a panel to try other faces, sizes and colours
   on the pages, and to copy the settings tried. It is off: resources/theme.js
   loads it only when a page is opened with ?tester, and keeps it for the
   browsing session (the tab); ?tester=off turns it off. It changes nothing
   for other readers, and saves nothing but in the reader's browser. */
(function () {
  'use strict';
  var here = (document.currentScript && document.currentScript.src) || 'resources/type-tester.js';
  var fonts = here.replace(/[^/]*$/, '') + 'fonts/';
  var KEY = 'opensheaf-site-tester';
  // [label, css family, Google Fonts family or null (local / system), group]
  var FACES = [
    ['IBM Plex Sans (current)', '"IBM Plex Sans"', null, 'Sans'],
    ['Geist (served by the site)', 'Geist', null, 'Sans'],
    ['Inter', 'Inter', 'Inter', 'Sans'],
    ['Source Sans 3', '"Source Sans 3"', 'Source Sans 3', 'Sans'],
    ['Public Sans', '"Public Sans"', 'Public Sans', 'Sans'],
    ['Work Sans', '"Work Sans"', 'Work Sans', 'Sans'],
    ['Figtree', 'Figtree', 'Figtree', 'Sans'],
    ['DM Sans', '"DM Sans"', 'DM Sans', 'Sans'],
    ['Manrope', 'Manrope', 'Manrope', 'Sans'],
    ['Instrument Sans', '"Instrument Sans"', 'Instrument Sans', 'Sans'],
    ['Atkinson Hyperlegible', '"Atkinson Hyperlegible"', 'Atkinson Hyperlegible', 'Sans'],
    ['System sans (SF / Segoe)', 'system-ui, -apple-system, "Segoe UI"', null, 'Sans'],
    ['Helvetica Neue (system)', '"Helvetica Neue", Helvetica, Arial', null, 'Sans'],
    ['CMU Serif (served by the site)', '"CMU Serif"', null, 'Serif'],
    ['Source Serif 4', '"Source Serif 4"', 'Source Serif 4', 'Serif'],
    ['Libertinus Serif', '"Libertinus Serif"', 'Libertinus Serif', 'Serif'],
    ['Newsreader', 'Newsreader', 'Newsreader', 'Serif'],
    ['Literata', 'Literata', 'Literata', 'Serif'],
    ['STIX Two Text', '"STIX Two Text"', 'STIX Two Text', 'Serif'],
    ['EB Garamond', '"EB Garamond"', 'EB Garamond', 'Serif'],
    ['Crimson Pro', '"Crimson Pro"', 'Crimson Pro', 'Serif'],
    ['Spectral', 'Spectral', 'Spectral', 'Serif'],
    ['Instrument Serif', '"Instrument Serif"', 'Instrument Serif', 'Serif'],
    ['Fraunces', 'Fraunces', 'Fraunces', 'Serif'],
    ['Charter (system)', 'Charter, "Bitstream Charter"', null, 'Serif'],
    ['Iowan Old Style (system)', '"Iowan Old Style"', null, 'Serif'],
    ['Palatino (system)', 'Palatino, "Palatino Linotype"', null, 'Serif'],
    ['Georgia (system)', 'Georgia', null, 'Serif']
  ];
  var MONOS = [
    ['JetBrains Mono (current)', '"JetBrains Mono"', null],
    ['Source Code Pro', '"Source Code Pro"', null],
    ['IBM Plex Mono', '"IBM Plex Mono"', 'IBM Plex Mono'],
    ['Geist Mono', '"Geist Mono"', 'Geist Mono'],
    ['Fira Code', '"Fira Code"', 'Fira Code'],
    ['SF Mono / Menlo (system)', 'ui-monospace, "SF Mono", Menlo', null]
  ];
  var DEFAULTS = {
    text: 0, title: -1, mono: 0,
    hbold: 0, hitalic: 0, size: 16.5, lead: 1.6, measure: 51, h1: 2.55, h2: 1.35, weight: 700, code: 0.72,
    colours: 0, paper: '#f9f8f5', ink: '#171716', muted: '#6a6861', surface: '#f1efea'
  };

  var state;
  try { state = JSON.parse(localStorage.getItem(KEY)) || {}; } catch (_) { state = {}; }
  for (var k in DEFAULTS) if (!(k in state)) state[k] = DEFAULTS[k];

  var loaded = {};
  function load(gf) {
    if (!gf || loaded[gf]) return;
    loaded[gf] = true;
    var base = 'https://fonts.googleapis.com/css2?family=' + gf.replace(/ /g, '+');
    // the full set may not exist for every family; the plain request always does
    [base + ':ital,wght@0,400;0,600;1,400;1,600&display=swap', base + '&display=swap'].forEach(function (href) {
      var l = document.createElement('link');
      l.rel = 'stylesheet';
      l.href = href;
      document.head.appendChild(l);
    });
  }

  var style = document.createElement('style');
  document.head.appendChild(style);
  function apply() {
    var t = FACES[state.text] || FACES[0], m = MONOS[state.mono] || MONOS[0];
    var h = state.title >= 0 ? FACES[state.title] : t;
    load(t[2]); load(h[2]); load(m[2]);
    var css =
      '@font-face{font-family:Geist;font-style:normal;font-weight:100 900;src:url("' + fonts + 'geist/Geist-Roman.woff2") format("woff2")}' +
      '@font-face{font-family:Geist;font-style:italic;font-weight:100 900;src:url("' + fonts + 'geist/Geist-Italic.woff2") format("woff2")}' +
      '@font-face{font-family:"CMU Serif";font-style:normal;font-weight:400;src:url("' + fonts + 'cmu/cmunrm.woff2") format("woff2")}' +
      '@font-face{font-family:"CMU Serif";font-style:italic;font-weight:400;src:url("' + fonts + 'cmu/cmunti.woff2") format("woff2")}' +
      '@font-face{font-family:"CMU Serif";font-style:normal;font-weight:600 700;src:url("' + fonts + 'cmu/cmunbx.woff2") format("woff2")}' +
      '@font-face{font-family:"CMU Serif";font-style:italic;font-weight:600 700;src:url("' + fonts + 'cmu/cmunbi.woff2") format("woff2")}' +
      ':root:root:root { --main-family: ' + t[1] + ', sans-serif !important; --title-family: ' + h[1] +
      ', sans-serif !important; --tt-family: ' + m[1] + ', monospace !important; --os-mono: ' + m[1] + ', monospace !important; }' +
      'body { font-family: var(--main-family) !important; }' +
      'h1, h2, h3, h4, h5, h6, .notes-header a:first-of-type { font-family: var(--title-family) !important; }' +
      'h1, h2, h3, h4, h5, h6 { font-weight: ' + (state.hbold ? 700 : state.weight) + ' !important; }' +
      (state.hitalic ? 'h1, h2, h3, h4, h5, h6 { font-style: italic !important; }' : '') +
      'tt, code, pre, .verbatim { font-family: var(--tt-family) !important; }' +
      'html { font-size: ' + state.size + 'px !important; }' +
      'body { line-height: ' + state.lead + ' !important; max-width: ' + state.measure + 'rem !important; }' +
      'h1 { font-size: ' + state.h1 + 'rem !important; }' +
      'h2 { font-size: ' + state.h2 + 'rem !important; }' +
      'div.tmweb-code, div.tmweb-code.hljs { font-size: ' + state.code + 'rem !important; }';
    if (state.colours) {
      css += ':root:root:root { --os-paper: ' + state.paper + ' !important; --os-ink: ' + state.ink +
        ' !important; --os-muted: ' + state.muted + ' !important; --os-surface: ' + state.surface + ' !important; }';
    }
    style.textContent = css;
    try { localStorage.setItem(KEY, JSON.stringify(state)); } catch (_) {}
  }
  apply();

  function describe() {
    var t = FACES[state.text] || FACES[0], m = MONOS[state.mono] || MONOS[0];
    var s = 'Site: text ' + t[0] + '; titles ' + (state.title >= 0 ? FACES[state.title][0] : 'same as the text') +
      '; code ' + m[0] + '; text size ' + state.size + 'px; leading ' + state.lead + '; column ' + state.measure +
      'rem; title ' + state.h1 + 'rem; sections ' + state.h2 + 'rem; heading weight ' + state.weight +
      '; code size ' + state.code + 'rem' + (state.hbold ? '; bold headings' : '') +
      (state.hitalic ? '; italic headings' : '');
    if (state.colours) s += '; colours paper ' + state.paper + ', ink ' + state.ink + ', muted ' + state.muted +
      ', surface ' + state.surface;
    return s;
  }

  function panel() {
    var css = document.createElement('style');
    css.textContent =
      '#tt{position:fixed;right:12px;bottom:12px;z-index:99;font:12px/1.4 system-ui,sans-serif;' +
      'color:var(--os-ink);background:var(--os-paper);border:1px solid var(--os-rule);border-radius:6px;' +
      'padding:10px 12px;width:270px;max-height:calc(100vh - 24px);overflow-y:auto;box-shadow:0 2px 10px rgba(0,0,0,.12)}' +
      '#tt label{display:block;margin:6px 0 2px;color:var(--os-muted)}' +
      '#tt select,#tt input[type=range]{width:100%;font:inherit}' +
      '#tt .row{display:flex;justify-content:space-between;align-items:center;gap:8px}' +
      '#tt input[type=color]{width:40px;height:20px;padding:0;border:0;background:none}' +
      '#tt button{font:inherit;margin-top:8px;background:none;border:1px solid var(--os-rule);' +
      'color:var(--os-ink);border-radius:4px;padding:2px 8px;cursor:pointer}' +
      '#tt h4{font:600 11px/1 system-ui,sans-serif;letter-spacing:.06em;text-transform:uppercase;' +
      'color:var(--os-muted);margin:12px 0 2px}' +
      '#tt.closed>*:not(.head){display:none}#tt.closed{width:auto}' +
      '#tt .head{display:flex;justify-content:space-between;gap:10px;font-weight:600;cursor:pointer}' +
      '#tt .msg{margin-top:6px;color:var(--os-muted);word-break:break-word}';
    document.head.appendChild(css);

    function options(list, key, same) {
      var out = same ? '<option value="-1"' + (state[key] < 0 ? ' selected' : '') + '>Same as the text</option>' : '';
      var group = null;
      list.forEach(function (f, i) {
        if (f[3] && f[3] !== group) { out += (group ? '</optgroup>' : '') + '<optgroup label="' + f[3] + '">'; group = f[3]; }
        out += '<option value="' + i + '"' + (i == state[key] ? ' selected' : '') + '>' + f[0] + '</option>';
      });
      return out + (group ? '</optgroup>' : '');
    }
    function sel(label, list, key, same) {
      return '<label>' + label + '</label><select data-k="' + key + '">' + options(list, key, same) + '</select>';
    }
    function range(label, key, min, max, step, unit) {
      return '<label class="row"><span>' + label + '</span><span data-v="' + key + '">' + state[key] + unit +
        '</span></label><input type="range" data-k="' + key + '" data-u="' + unit + '" min="' + min +
        '" max="' + max + '" step="' + step + '" value="' + state[key] + '">';
    }
    function colour(label, key) {
      return '<label class="row"><span>' + label + '</span><input type="color" data-c="' + key + '" value="' + state[key] + '"></label>';
    }
    function check(label, key) {
      return '<label class="row"><span>' + label + '</span><input type="checkbox" data-b="' + key + '"' +
        (state[key] ? ' checked' : '') + '></label>';
    }
    var weights = [300, 400, 500, 600, 700].map(function (w) {
      return '<option value="' + w + '"' + (w == state.weight ? ' selected' : '') + '>' + w + '</option>';
    }).join('');

    var box = document.createElement('div');
    box.id = 'tt';
    if (state.closed) box.className = 'closed';
    box.innerHTML = '<div class="head"><span>Type tester</span><span class="tg">' + (state.closed ? '+' : '–') + '</span></div>' +
      '<h4>Faces</h4>' +
      sel('Text', FACES, 'text') + sel('Titles (and the name in the masthead)', FACES, 'title', true) +
      sel('Code', MONOS, 'mono') +
      '<label>Heading weight</label><select data-k="weight">' + weights + '</select>' +
      check('Bold headings (700)', 'hbold') + check('Italic headings (all levels)', 'hitalic') +
      '<h4>Sizes</h4>' +
      range('Text size', 'size', 14, 22, 0.5, 'px') +
      range('Leading', 'lead', 1.3, 1.9, 0.05, '') +
      range('Column', 'measure', 32, 56, 1, 'rem') +
      range('Page title', 'h1', 1.6, 3.6, 0.05, 'rem') +
      range('Sections', 'h2', 1, 2.2, 0.05, 'rem') +
      range('Code size', 'code', 0.6, 1, 0.01, 'rem') +
      '<h4>Colours</h4>' +
      check('Use these colours (both themes)', 'colours') +
      colour('Paper', 'paper') + colour('Ink', 'ink') + colour('Secondary text', 'muted') + colour('Surface (code, notes)', 'surface') +
      '<div><button type="button" class="copy">Copy settings</button> <button type="button" class="reset">Reset</button></div>' +
      '<div class="msg"></div>';
    document.body.appendChild(box);

    box.querySelector('.head').onclick = function () {
      state.closed = !state.closed;
      box.classList.toggle('closed', state.closed);
      box.querySelector('.tg').textContent = state.closed ? '+' : '–';
      apply();
    };
    box.addEventListener('input', function (e) {
      var el = e.target, k;
      if ((k = el.getAttribute('data-k'))) {
        state[k] = parseFloat(el.value);
        var v = box.querySelector('[data-v="' + k + '"]');
        if (v) v.textContent = el.value + el.getAttribute('data-u');
      } else if ((k = el.getAttribute('data-c'))) {
        state[k] = el.value;
      } else if ((k = el.getAttribute('data-b'))) {
        state[k] = el.checked ? 1 : 0;
      } else return;
      apply();
    });
    box.querySelector('.reset').onclick = function () {
      var closed = state.closed;
      state = JSON.parse(JSON.stringify(DEFAULTS));
      state.closed = closed;
      apply();
      location.reload();
    };
    box.querySelector('.copy').onclick = function () {
      var text = describe(), msg = box.querySelector('.msg');
      function fallback() {
        var ta = document.createElement('textarea');
        ta.value = text;
        ta.style.cssText = 'width:100%;height:7em;font:11px/1.3 ui-monospace,monospace';
        msg.innerHTML = '';
        msg.appendChild(ta);
        ta.select();
        var ok = false;
        try { ok = document.execCommand('copy'); } catch (_) {}
        msg.insertAdjacentText('afterbegin', ok ? 'Copied:' : 'Select and copy:');
      }
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(function () { msg.textContent = 'Copied: ' + text; }, fallback);
      } else fallback();
    };
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', panel);
  else panel();
}());
