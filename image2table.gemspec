# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'image2table/version'

Gem::Specification.new do |spec|
  spec.name          = "image2table"
  spec.version       = Image2table::VERSION
  spec.authors       = ["LesPepitos"]
  spec.email         = ["shakaman@lespepitos.org"]
  spec.summary       = ""
  spec.description   = "Tool to convert image to table html"
  spec.homepage      = "https://github.com/LesPepitos/image2table"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rmagick",  "~> 2.15"

  spec.add_development_dependency "bundler",  "~> 1.7"
  spec.add_development_dependency "rake",     "~>10.1"
  spec.add_development_dependency "rspec",    "~> 3.2"
end
