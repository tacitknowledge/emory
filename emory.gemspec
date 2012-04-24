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
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
end
