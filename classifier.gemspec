# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "classifier/version"

Gem::Specification.new do |s|
  s.name        = "classifier"
  s.version     = Classifier::VERSION
  s.authors     = ["cardmagic"]
  s.email       = ["lucas@rufy.com"]
  s.homepage    = "https://github.com/helloqidi/classifier"
  s.summary     = %q{Simple text classifier(s) implemetation}
  s.description = %q{Classifier is a general module to allow Bayesian and other types of classifications}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.9.1'
  
  s.add_runtime_dependency "fast-stemmer"
  s.add_runtime_dependency "rmmseg-cpp"
  s.add_runtime_dependency "redis"

  s.add_development_dependency "rake", ">= 0.9.2"

end
