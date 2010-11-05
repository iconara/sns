# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sns/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'sns'
  s.version     = Sns::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Theo Hultberg']
  s.email       = ['theo@iconara.net']
  s.homepage    = 'http://github.com/iconara/sns'
  s.summary     = 'Amazon SNS interface'
  s.description = 'Amazon SNS interface'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'sns'

  s.add_development_dependency 'bundler', '>= 1.0.0'
  
  s.add_runtime_dependency 'typhoeus'
  s.add_runtime_dependency 'ruby-hmac'

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
