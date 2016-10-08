require "slideit/version"
require "slideit/container"

require 'webrick'

module Slideit
  def self.show(file, options)
    Container.new(file, options).start
  end
end
