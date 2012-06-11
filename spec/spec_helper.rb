if RUBY_VERSION =~ /1.9/
  require 'simplecov'
  SimpleCov.start
end

require 'rspec'
require 'logging'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
