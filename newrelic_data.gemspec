# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'newrelic_data'
 
Gem::Specification.new do |s|
  s.name        = "newrelic_data"
  s.version     = NewRelicData::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Joshua Mervine"]
  s.email       = ["joshua@mervine.net"]
  s.homepage    = "http://github.com/jmervine/newrelic_data"
  s.summary     = "NewRelic Data access API"
  s.description = "Simple utility for access NewRelic data through their RESTful API."
 
  s.required_rubygems_version = ">= 1.3.6"
 
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "yard"
  s.add_development_dependency "redcarpet"

  s.add_dependency "curb"
  s.add_dependency "xml-simple"
 
  s.files        = Dir.glob("lib/**/*") + %w(README.md HISTORY.md Gemfile)
  s.require_path = 'lib'
end

