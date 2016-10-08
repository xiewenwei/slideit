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
  end
end