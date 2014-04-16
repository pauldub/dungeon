# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dungeon/version'

Gem::Specification.new do |spec|
  spec.name          = "dungeon"
  spec.version       = Dungeon::VERSION
  spec.authors       = ["Paul d'Hubert"]
  spec.email         = ["paul@tymate.com"]
  spec.summary       = %q{Game engine}
  spec.description   = %q{A simple game engine: for the fun}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "chingu"
  spec.add_runtime_dependency "fidgit"
  spec.add_runtime_dependency "pry"
  spec.add_runtime_dependency "rmagick"
end
