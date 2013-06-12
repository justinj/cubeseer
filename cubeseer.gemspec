# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "cubeseer/version"

Gem::Specification.new do |s|
  s.name        = "cubeseer"
  s.version     = CubeSeer::VERSION
  s.author      = "Justin Jaffray"
  s.email       = ["justin.jaffray@gmail.com"]
  s.homepage    = "https://github.com/justinj/cubeseer"
  s.license     = "MIT"

  s.summary     = %q{Rubik's Cube diagrams generated in Ruby}
  s.description = %q{VisualCube for Ruby}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency "quick_magick"

  s.add_development_dependency "minitest"
  s.add_development_dependency "rake"
  s.add_development_dependency "sinatra"
end
