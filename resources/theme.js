/* The theme: a visit opens in the default theme, which follows the system
   preference (also without JavaScript, through CSS). A single button switches
   between light and dark; the choice is kept for the browsing session (the
   tab), so that every page of the visit uses it, and forgotten afterwards.
   It is applied here, in the head, before the page is painted. */
(function () {
  'use strict';
  var key = 'opensheaf-theme';
  var root = document.documentElement;
  var media = window.matchMedia ? window.matchMedia('(prefers-color-scheme: dark)') : null;

  function apply(value) {
    if (value === 'light' || value === 'dark') root.setAttribute('data-theme', value);
    else root.removeAttribute('data-theme');
  }
  try { apply(sessionStorage.getItem(key)); } catch (_) { apply(null); }

  function current() {
    var set = root.getAttribute('data-theme');
    if (set === 'light' || set === 'dark') return set;
    return media && media.matches ? 'dark' : 'light';
  }

  document.addEventListener('DOMContentLoaded', function () {
    var control = document.createElement('div');
    control.className = 'theme-control';
    var button = document.createElement('button');
    button.type = 'button';
    button.className = 'theme-toggle';

    function describe() {
      var next = current() === 'dark' ? 'light' : 'dark';
      button.setAttribute('aria-label', 'Switch to the ' + next + ' theme');
      button.title = 'Switch to the ' + next + ' theme';
    }

    button.addEventListener('click', function () {
      var next = current() === 'dark' ? 'light' : 'dark';
      apply(next);
      try { sessionStorage.setItem(key, next); } catch (_) { /* the page still switches */ }
      describe();
    });
    if (media && media.addEventListener) media.addEventListener('change', describe);

    describe();
    control.appendChild(button);
    document.body.insertBefore(control, document.body.firstChild);
  });

  /* The masthead marks the page being read. */
  document.addEventListener('DOMContentLoaded', function () {
    var here = location.pathname.replace(/\/$/, '/index.html').split('/').pop();
    var links = document.querySelectorAll('.notes-header a');
    Array.prototype.forEach.call(links, function (link) {
      var href = link.getAttribute('href') || '';
      if (!/^[a-z]+:/i.test(href) && href.split('#')[0] === here) {
        link.setAttribute('aria-current', 'page');
      }
    });
  });

  /* Syntax highlighting: the pages are converted from Markdown, where a code
     block's language (```sh, ```json) becomes a wrapper with the class
     language-<name>; the site's highlighter (notes-base.js, highlight.js)
     reads the class on the code block itself, so it is copied there. Blocks
     without a language are not highlighted, rather than guessed. This
     listener is registered before the highlighter's, so it runs first. */
  document.addEventListener('DOMContentLoaded', function () {
    var blocks = document.querySelectorAll('.tmweb-code');
    Array.prototype.forEach.call(blocks, function (block) {
      var wrap = block.parentElement;
      var lang = wrap && /(?:^|\s)(language-[\w-]+)/.exec(wrap.className || '');
      block.classList.add(lang ? lang[1] : 'nohighlight');
    });
  });
}());
