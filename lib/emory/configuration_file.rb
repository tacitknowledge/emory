require 'emory/emory_logger'
require 'pathname'

module Emory

  class EmoryConfigurationFileNotFoundException < Exception; end

  class ConfigurationFile

    class << self

      def locate
        Pathname.new(Dir.pwd).ascend do |dir|
          logger.debug "Examining directory: #{dir}"
          config_file = File.join(dir, ".emory")
          next unless File.exists?(config_file)
          logger.info "Found config file: #{config_file}"
          return config_file
        end

        raise EmoryConfigurationFileNotFoundException, 'Configuration file (.emory) was not found'
      end

      private

      def logger
        @logger ||= Emory::Logger.log_for(self)
      end

    end

  end

end
