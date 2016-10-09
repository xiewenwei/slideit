require 'test_helper'

module Slideit
  class TemplateTest < Minitest::Test
    def test_render
      markdown = "## Demo 1\n\rSlide 1\n\r---\n\r## Demo 1\n\rSlide 2"
      template = Template.new "ItIsMySlide", markdown
      html = template.render
      assert_match /<title>ItIsMySlide - slideit<\/title>/, html
      assert_match /## Demo 1/, html
    end

    def test_print_pdf
      template = Template.new "title", "demo", pdf: true
      html = template.render
      assert html.index("window.onload = function() { window.print")
    end
  end
end
