# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'enumize_mongoid/version'

Gem::Specification.new do |spec|
  spec.name          = "enumize_mongoid"
  spec.version       = EnumizeMongoid::VERSION
  spec.authors       = ["Elod Peter"]
  spec.email         = ["bejmuller@gmail.com"]

  spec.summary       = %q{Enum Field for Mongoid}
  spec.description   = %q{Enum Field for Mongoid}
  spec.homepage      = "https://github.com/InnovativeTravel/enumize_mongoid"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "mongoid", "~> 5.0"
  spec.required_ruby_version = "~> 2.2"
end
