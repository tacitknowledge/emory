#!/usr/bin/env rake

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/test*.rb']
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')

require 'bundler'
Bundler::GemHelper.install_tasks

desc "Run rspec tests"
task :default => :spec