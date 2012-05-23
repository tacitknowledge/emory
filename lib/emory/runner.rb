require 'listen'
require 'emory/configuration_file'
require 'emory/dsl'

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
          config = Emory::Dsl.instance_eval_emoryfile(emory_config_contents, emory_config_file)

          LOGGER.debug('Configuring listeners')
          configure_listeners(config)

          Thread.current.join
        rescue Interrupt
          LOGGER.info('Shutting down Emory')
        rescue Exception => e
          LOGGER.error(e)
        end
      end

      private
      
      def configure_listeners(config)
        config.teleports.each do |teleport|
          listener = Listen.to(teleport.watched_path)
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
    end
  end

end
