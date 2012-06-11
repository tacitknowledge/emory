require 'listen'
require 'pathname'
require 'emory/configuration_file'
require 'emory/dsl/dsl'

module Emory

  class Runner

    LOGGER = Logging.logger[self]

    class << self
      def start
        begin
          LOGGER.debug('Looking for the configuration file')
          emory_config_file = ConfigurationFile.locate

          LOGGER.debug('Reading configuration file contents')
          emory_config_contents = File.read(emory_config_file)

          LOGGER.debug("Evaluating configuration file contents:\n====\n#{emory_config_contents}===")
          config = DSL::Dsl.instance_eval_emoryfile(emory_config_contents, emory_config_file)

          LOGGER.debug('Configuring listeners')
          configure_listeners(config, File.dirname(emory_config_file))

          Thread.stop
        rescue Interrupt
          LOGGER.info('Shutting down Emory')
        rescue EmoryConfigurationFileNotFoundException => fileNotFoundException
          LOGGER.error("#{fileNotFoundException.message}. Please refer to http://tacitknowledge.com/emory for information on how to use Emory.")
        rescue Exception => e
          LOGGER.error(e)
        end
      end

      private
      
      def configure_listeners(config, config_location)
        LOGGER.debug("Config\'s directory is: #{config_location}")
        config.teleports.each do |teleport|
          watched_path = normalize_watched_path(config_location, teleport.watched_path)
          LOGGER.info("Watching directory: #{watched_path}")

          listener = Listen.to(watched_path)
          listener.ignore(teleport.ignore) unless teleport.ignore.nil?
          listener.filter(teleport.filter) unless teleport.filter.nil?
          listener.change(&get_handler_callback(teleport.handler))
          listener.start(false)
        end
      end

      def get_handler_callback(handler)
        Proc.new do |modified, added, removed|
          trigger_handler_method(modified, handler, :modified)
          trigger_handler_method(added, handler, :added)
          trigger_handler_method(removed, handler, :removed)
        end
      end

      def trigger_handler_method(paths, handler, operation)
        unless paths.empty?
          paths.each { |path| handler.send(operation, path) } if handler.respond_to?(operation)
        end
      end

      def normalize_watched_path(config_location, watched_path)
        return watched_path if Pathname.new(watched_path).absolute?
        File.expand_path(watched_path, config_location)
      end

    end
  end

end
