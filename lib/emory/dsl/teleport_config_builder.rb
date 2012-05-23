require 'emory/teleport_config'

module Emory
  module DSL

    class TeleportConfigurationBlockMustBeSuppliedException < Exception; end
    class UndefinedTeleportHandlerException < Exception; end
    class HandlerReferenceMustBeSuppliedException < Exception; end
    class WatchedPathMustBeSuppliedException < Exception; end

    class TeleportConfigBuilder

      LOGGER = Logging.logger[self]

      def initialize(handlers, &block)
        LOGGER.debug('Initializing a new teleport builder')
        raise TeleportConfigurationBlockMustBeSuppliedException, "The configuration block with teleport settings must be supplied" unless block_given?

        @block = block
        @available_handlers = handlers

        LOGGER.debug('Creating a new teleport config instance')
        @teleport_config = TeleportConfig.new
      end

      def build
        LOGGER.debug('Evaluating teleport configuration')
        instance_eval &@block

        raise HandlerReferenceMustBeSuppliedException, "A reference to an existing handler must be supplied in teleport configuration" if @teleport_config.handler.nil?
        raise WatchedPathMustBeSuppliedException, "A watched path must be supplied in teleport configuration" if @teleport_config.watched_path.nil?

        @teleport_config
      end

      private

      def path(path)
        LOGGER.debug('Setting teleport\'s watched path')
        @teleport_config.watched_path = path
      end

      def handler(handler_name)
        LOGGER.debug('Setting teleport\'s handler')
        raise UndefinedTeleportHandlerException, "The handler ':#{handler_name}' wired to teleport could not be found" unless @available_handlers.include?(handler_name)
        @teleport_config.handler = @available_handlers[handler_name]
      end

      def ignore(ignore)
        LOGGER.debug('Setting teleport\'s ignore expression')
        @teleport_config.ignore = ignore
      end

      def filter(filter)
        LOGGER.debug('Setting teleport\'s filter expression')
        @teleport_config.filter = filter
      end

    end

  end
end
