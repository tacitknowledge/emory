require 'logging'
require 'emory/teleport_config'
require 'emory/handler_builder'

module Emory

  class EmoryMisconfigurationException < Exception; end
  class DuplicateHandlerNameException < Exception; end
  class UndefinedTeleportHandlerException < Exception; end

  class Dsl

    LOGGER = Logging.logger[self]
    ALLOWED_HANDLER_ACTIONS = [:all, :added, :modified, :removed]

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

    def teleport(watched_dir, handler_name, options = {})
      raise UndefinedTeleportHandlerException, "The handler ':#{handler_name}' wired to teleport could not be found" unless handlers.include?(handler_name)

      config = TeleportConfig.new
      config.watched_path = watched_dir
      config.handler = handlers[handler_name]
      config.filter = options[:filter] if options.include?(:filter)
      config.ignore = options[:ignore] if options.include?(:ignore)

      teleports << config
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
