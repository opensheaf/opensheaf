<TeXmacs|2.1.5>

<style|source>

<\body>
  <\active*>
    <\src-title>
      <src-package|notes-meta|1.0>

      <src-purpose|Site style for the pages of the OpenSheaf repository (the
      specification). Stylesheets and scripts are in
      resources/, given by relative paths, which work on the web server and
      from the file system.>

      <src-copyright|2026|Massimiliano Gubinelli>
    </src-title>
  </active*>

  <assign|notes-main-dir|https://mgubi.org/docs>

  <assign|notes-meta-name|papers>

  <\active*>
    <\src-comment>
      The header names the site and links to the first OpenSheaf archive.
    </src-comment>
  </active*>

  <assign|notes-header-links|<macro|[<hlink|OpenSheaf|index.tm>]
  [<hlink|specification|opensheaf-specification-0.1.tm>] [<hlink|use
  cases|use-cases.tm>] [<hlink|FAQ|faq.tm>]
  [<hlink|first archive|https://mgubi.org/papers/>]>>

  <assign|notes-header-name|OpenSheaf>

  <\active*>
    <\src-comment>
      The OpenSheaf look: black ink on a warm white paper, without colour;
      headings in the serif of the text, in its regular weight.
    </src-comment>
  </active*>

  <assign|notes-heading|<macro|body|<with|font-family|rm|font-series|medium|color|#171716|<arg|body>>>>

  <assign|notes-title-color|#171716>

  <assign|notes-text-color|#171716>

  <assign|notes-background-color|#f9f8f5>

  <assign|color|#171716>

  <assign|bg-color|#f9f8f5>

  <assign|locus-color|#171716>

  <assign|visited-color|#171716>

  <\active*>
    <\src-comment>
      Alert boxes, from GitHub's alert syntax in the Markdown sources (\<gtr\>
      [!WARNING], [!NOTE], [!IMPORTANT]): a box with a coloured rule on
      its left in TeXmacs (os-alert-box: a one-cell table, since the
      padded-framed macro is not defined in TeXmacs 2.1; borders take the
      colour of the table, so the table is set in the colour of the rule and
      the cell's content back in the colour of the text), with the colours
      of the web, where it is a div of class os-alert (with the kind as a
      second class).
    </src-comment>
  </active*>

  <assign|os-alert-box|<macro|rule|paper|ink|body|<surround|<vspace*|0.5fn>|<vspace|0.5fn>|<with|color|<arg|rule>|<tformat|<twith|table-width|1par>|<twith|table-hmode|exact>|<twith|table-block|yes>|<cwith|1|1|1|1|cell-hyphen|t>|<cwith|1|1|1|1|cell-background|<arg|paper>>|<cwith|1|1|1|1|cell-lborder|3pt>|<cwith|1|1|1|1|cell-lsep|1em>|<cwith|1|1|1|1|cell-rsep|1em>|<cwith|1|1|1|1|cell-tsep|0.6em>|<cwith|1|1|1|1|cell-bsep|0.6em>|<table|<row|<\cell>
    <with|color|<arg|ink>|<arg|body>>
  </cell>>>>>>>>

  <assign|os-alert|<macro|kind|label|body|<if|<equal|<arg|kind>|note>|<os-alert-box|#dedbd3|#f1efea|#171716|<with|font-series|bold|<arg|label>>
  <arg|body>>|<os-alert-box|#dedbd3|#f1efea|#171716|<with|font-series|bold|color|#7d5200|<arg|label>>
  <arg|body>>>>>

  <assign|tmhtml-os-alert|<macro|kind|label|body|<html-div-class|os-alert
  os-<arg|kind>|<html-class|os-alert-label|<arg|label>> <arg|body>>>>

  <\active*>
    <\src-comment>
      Technical terms where they are defined (\<less\>dfn\<gtr\> in the
      Markdown sources): in italics, as in a mathematical text; exported to HTML
      as dfn elements, styled the same way by resources/opensheaf.css.
    </src-comment>
  </active*>

  <assign|dfn|<macro|body|<em|<arg|body>>>>

  <assign|html-title|OpenSheaf>

  <assign|html-head-favicon|resources/brand/favicon.svg>

  <assign|html-head-javascript-src|<tuple|resources/theme.js>>

  <assign|html-css|resources/notes-base.css>

  <assign|html-extra-css|<tuple|resources/opensheaf.css>>

  <assign|html-extra-javascript-src|<tuple|resources/highlight.pack.js|resources/notes-base.js>>
</body>

<\initial>
  <\collection>
    <associate|preamble|true>
  </collection>
</initial>
