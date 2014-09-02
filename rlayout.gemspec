# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rlayout/version'

Gem::Specification.new do |spec|
  spec.name          = "rlayout"
  spec.version       = Rlayout::VERSION
  spec.authors       = ["Min Soo Kim"]
  spec.email         = ["mskimsid@gmail.com"]
  spec.summary       = %q{Ruby DSL for creating page layout.}
  spec.description   = %q{Ruby DSL for the next generation publishing solutions.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
