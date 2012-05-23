require 'simplecov'
SimpleCov.start

require 'rspec'
require 'logging'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
