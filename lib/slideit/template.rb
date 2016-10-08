require 'cgi'

module Slideit
  class Template
    Themes = %w(beige black blood league moon night serif simple sky solarized white)
    Default = {
      :separator => "^\n---\n",
      :"separator-vertical" => "^\n----\n",
      :"separator-notes" => "^Note:",
      :theme => "league"
    }
    BASE = <<-REVEAL_JS_TEMPLATE
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">

    <title>{__slide_title__}</title>

    <meta name="description" content="A framework for easily creating beautiful presentations using HTML">
    <meta name="author" content="Hakim El Hattab">

    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">

    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

    <link rel="stylesheet" href="/css/reveal.css">
    <link rel="stylesheet" href="/css/theme/{__theme__}.css" id="theme">

    <!-- Theme used for syntax highlighting of code -->
    <link rel="stylesheet" href="/lib/css/zenburn.css">

    <!-- Printing and PDF exports -->
    <script>
      var link = document.createElement( 'link' );
      link.rel = 'stylesheet';
      link.type = 'text/css';
      link.href = window.location.search.match( /print-pdf/gi ) ? 'css/print/pdf.css' : 'css/print/paper.css';
      document.getElementsByTagName( 'head' )[0].appendChild( link );
    </script>

    <!--[if lt IE 9]>
    <script src="lib/js/html5shiv.js"></script>
    <![endif]-->
  </head>

  <body>

    <div class="reveal">

      <div class="slides">

        <section data-markdown
          data-separator="{__separator__}"
          data-separator-vertical="{__separator-vertical__}"
          data-separator-notes="{__separator-notes__}"
          data-charset="utf-8">
          <script type="text/template">
{__slide_markdown__}
          </script>
        </section>

      </div>

    </div>

    <script src="/lib/js/head.min.js"></script>
    <script src="/js/reveal.js"></script>

    <script>

      // More info https://github.com/hakimel/reveal.js#configuration
      Reveal.initialize({
        controls: true,
        progress: true,
        history: true,
        center: true,

        transition: 'slide', // none/fade/slide/convex/concave/zoom

        // More info https://github.com/hakimel/reveal.js#dependencies
        dependencies: [
          { src: '/lib/js/classList.js', condition: function() { return !document.body.classList; } },
          { src: '/plugin/markdown/marked.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
          { src: '/plugin/markdown/markdown.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
          { src: '/plugin/highlight/highlight.js', async: true, callback: function() { hljs.initHighlightingOnLoad(); } },
          { src: '/plugin/zoom-js/zoom.js', async: true },
          { src: '/plugin/notes/notes.js', async: true }
        ]
      });

      {__print-pdf-scrit__}

    </script>

  </body>
</html>
    REVEAL_JS_TEMPLATE

    def initialize(title, markdown, options = {})
      @title = title
      @markdown = markdown
      @options = Default.dup
      @options.update options

      # make sure theme exists
      unless Themes.include?(@options[:theme])
        @options[:theme] = Default[:theme]
      end
    end

    TITLE_PATTERN = "{__slide_title__}"
    MARKDOWN_PATTERN = "{__slide_markdown__}"
    THEME_PATTERN = "{__theme__}"
    SEPARATOR_PATTERN = "{__separator__}"
    SEPARATOR_VERTICAL_PATTERN = "{__separator-vertical__}"
    SEPARATOR_NOTES_PATTERN = "{__separator-notes__}"
    PRINT_PDF_PATTERN = "{__print-pdf-scrit__}"

    def render
      html = BASE.dup
      html.sub! TITLE_PATTERN, "#{CGI::escapeHTML(@title)} - slideit"
      html.sub! MARKDOWN_PATTERN, @markdown
      html.sub! THEME_PATTERN, @options[:theme]
      html.sub! SEPARATOR_PATTERN, @options[:separator]
      html.sub! SEPARATOR_VERTICAL_PATTERN, @options[:"separator-vertical"]
      html.sub! SEPARATOR_NOTES_PATTERN, @options[:"separator-notes"]
      html.sub! PRINT_PDF_PATTERN, print_pdf_script
      html
    end

    private

    def print_pdf_script
      if @options[:pdf]
        "window.onload = function() { window.print(); };"
      else
        ""
      end
    end
  end
end