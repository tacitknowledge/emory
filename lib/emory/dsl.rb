require 'emory/teleport_config'

module Emory

  class EmoryMisconfigurationException < Exception; end
  class DuplicateHandlerNameException < Exception; end
  class HandlerActionAllMustBeSingletonException < Exception; end
  class HandlerActionMustBeSuppliedException < Exception; end
  class HandlerActionUnsupportedException < Exception; end
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

    def handler(handler_name, class_name, options, *actions)
      uniq_actions = actions.uniq

      raise DuplicateHandlerNameException, "The handler name ':#{handler_name}' is defined more than once" if handlers.include?(handler_name)
      raise HandlerActionMustBeSuppliedException, "At least one handler action needs to be supplied to ':#{handler_name}'" if actions.empty?
      raise HandlerActionAllMustBeSingletonException, "The handler action ':#{:all}' cannot be mixed with other types" if uniq_actions.include?(:all) and uniq_actions.size > 1
      actions.each do |action|
        raise HandlerActionUnsupportedException,
              "The action ':#{action}' supplied to handler ':#{handler_name}' is unsupported. Supported actions are #{ALLOWED_HANDLER_ACTIONS}." unless ALLOWED_HANDLER_ACTIONS.include?(action)
      end

      handler = class_name.new(options)

      if uniq_actions[0] != :all
        handler.instance_eval { undef :added } unless uniq_actions.include?(:added)
        handler.instance_eval { undef :modified } unless uniq_actions.include?(:modified)
        handler.instance_eval { undef :removed } unless uniq_actions.include?(:removed)
      end

      handlers[handler_name] = handler
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

    def handlers
      @handlers ||= {}
    end

    def teleports
      @teleports ||= []
    end
    
  end

end
