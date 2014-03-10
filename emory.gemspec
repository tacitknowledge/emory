# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'emory/version'

Gem::Specification.new do |s|
  s.name          = 'emory'
  s.version       = Emory::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Vladislav Gangan', 'Scott Askew', 'Ion Lenta']
  s.email         = ['vgangan@tacitknowledge.com', 'scott@tacitknowledge.com', 'ilenta@tacitknowledge.com']
  s.homepage      = 'http://tacitknowledge.com/emory'
  s.summary       = 'Invokes a configured action when something interesting happens to a monitored file'
  s.description   = 'The Emory gem listens to file modifications and runs an action against it (for example, upload to a remote location)'

  s.files         = `git ls-files`.split($\)
  s.executables   = %w(emory)
  s.test_files    = Dir.glob("{spec,test}/**/*.rb")
  s.require_paths = ["lib"]
  
  s.add_development_dependency 'rspec', '2.14.1'
  s.add_development_dependency 'simplecov', '0.8.2' if RUBY_VERSION =~ /1.9/
  s.add_development_dependency 'rake'

  s.add_runtime_dependency 'logging', '1.8.2'
  s.add_runtime_dependency 'listen', '2.7.0'
end
