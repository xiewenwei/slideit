# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slideit/version'

Gem::Specification.new do |spec|
  spec.name          = "slideit"
  spec.version       = Slideit::VERSION
  spec.authors       = ["vincent"]
  spec.email         = ["xiewenwei@gmail.com"]

  spec.summary       = %q{Slides prensenter based on RevealJS HTML.}
  spec.description   = %q{Slides prensenter based on RevealJS HTML.}
  spec.homepage      = "http://github.com/xiewenwie/slideit."

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.bindir        = "bin"
  spec.executables   = ["slideit"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
