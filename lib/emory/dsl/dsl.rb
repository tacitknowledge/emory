require 'emory/teleport_config'
require 'emory/dsl/handler_builder'
require 'emory/dsl/teleport_config_builder'

module Emory
  module DSL

    class EmoryMisconfigurationException < Exception; end
    class DuplicateHandlerNameException < Exception; end

    class Dsl

      LOGGER = Logging.logger[self]

      class << self
        def instance_eval_emoryfile(contents, config_path)
          config = new
          config.instance_eval(contents, config_path, 1)
          config.handlers.freeze
          config.teleports.freeze
          config
        rescue
          LOGGER.error("Incorrect contents of .emory file, original error is:\n#{ $! }")
          raise EmoryMisconfigurationException, 'Incorrect contents of .emory file'
        end
      end

      def teleport(&block)
        teleport_builder = TeleportConfigBuilder.new(handlers, &block)
        teleport = teleport_builder.build
        teleports << teleport
        LOGGER.debug("Processed and added #{teleport} to the list: #{teleports}")
      end

      def handler(&block)
        handler_builder = HandlerBuilder.new(&block)
        handler = handler_builder.build
        raise DuplicateHandlerNameException, "The handler name ':#{handler.name}' is defined more than once" if handlers.include?(handler.name)
        handlers[handler.name] = handler
        LOGGER.debug("Processed and added ':#{handler.name}' to the list: #{handlers}")
      end

      def handlers
        @handlers ||= {}
      end

      def teleports
        @teleports ||= []
      end

    end

  end
end
