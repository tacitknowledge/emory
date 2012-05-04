require 'rspec'
require 'emory/configuration_file'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
