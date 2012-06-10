require 'pathname'

module Emory

  class EmoryConfigurationFileNotFoundException < Exception; end

  class ConfigurationFile

    LOGGER = Logging.logger[self]
    CONFIG_FILE_NAME = ".emory"

    class << self

      def locate
        Pathname.new(Dir.pwd).ascend do |dir|
          LOGGER.debug "Examining directory: #{dir}"
          config_file = File.join(dir, CONFIG_FILE_NAME)
          next unless File.exists?(config_file)
          LOGGER.info "Found config file: #{config_file}"
          return config_file
        end

        raise EmoryConfigurationFileNotFoundException, 'Configuration file (.emory) was not found'
      end
    end

  end

end
