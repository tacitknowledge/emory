require 'emory/configuration_file'

module Emory

  class Runner
    class << self
      def start
        emory_config_file = ConfigurationFile.read
        
        #TODO: listening for folders from configuration file
        #      and trigger corresponding handler
        
      end
    end
  end

end