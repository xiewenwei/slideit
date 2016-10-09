require 'test_helper'

module Slideit
  class ContainerTest < Minitest::Test
    def test_asset_files
      test_file = File.expand_path "../../test.md", __FILE__
      container = Container.new test_file
      files = container.send :asset_files
      assert_equal 2, files.size
      assert_equal File.expand_path("../../images/redis.png", __FILE__), files["/images/redis.png"]
      assert_equal File.expand_path("../../redis.png", __FILE__), files["/redis.png"]
    end
  end
end