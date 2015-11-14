# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shle/version'

Gem::Specification.new do |s|
  s.name          = "shle"
  s.version       = Shle::VERSION
  s.authors       = ["Jakub Hozak"]
  s.email         = ["jakub.hozak@gmail.com"]
  s.summary       = %q{Sinfin Heavily Lightweight Establisher}
  s.description   = %q{Generates new Rails project, with basic Ember structure baked-in. Based on Rails generators and inspired by Suspenders.}
  s.homepage      = "http://github.com/sinfin/shle"
  s.license       = "MIT"

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'rails', '4.2'
  s.add_dependency 'bundler'

  s.add_development_dependency "bundler", "~> 1.7"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "pry"
end
