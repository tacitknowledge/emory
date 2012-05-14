# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'emory/version'

Gem::Specification.new do |s|
  s.name          = 'emory'
  s.version       = Emory::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Scott Askew', 'Vladislav Gangan', 'Ion Lenta']
  s.email         = ['scott@tacitknowledge.com', 'vgangan@tacitknowledge.com', 'ilenta@tacitknowledge.com']
  s.homepage      = 'https://github.com/tacitknowledge/emory'
  s.summary       = 'Invokes a configured action when something interesting happens to a monitored file'
  s.description   = 'The Emory gem listens to file modifications and runs an action against it (for example, upload to a remote location)'

  s.files         = `git ls-files`.split($\)
  s.executables   = %w(emory)
  s.test_files    = Dir.glob("{spec,test}/**/*.rb")
  s.require_paths = ["lib"]
  
  s.add_development_dependency 'rspec', '~> 2.10'
  s.add_development_dependency 'simplecov', '~> 0.6.2'
  s.add_development_dependency 'rake'

  s.add_runtime_dependency 'logging'
  s.add_runtime_dependency 'listen'
end
