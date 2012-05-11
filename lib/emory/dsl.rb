module Emory

  class EmoryMisconfigurationException < Exception; end
  class DuplicateHandlerNameException < Exception; end
  class HandlerActionAllMustBeSingletonException < Exception; end
  class HandlerActionMustBeSuppliedException < Exception; end
  class UndefinedTeleportHandlerException < Exception; end

  class Dsl
    class << self
      def instance_eval_emoryfile(contents, config_path)
        config = new
        config.instance_eval(contents, config_path, 1)
        config
      rescue Exception => e
        puts "Incorrect contents of .emory file, original error is:\n#{ $! }"
        raise EmoryMisconfigurationException, 'Incorrect contents of .emory file'
      end
    end

    def handler(handler_name, class_name, options, *actions)
      raise DuplicateHandlerNameException, "The handler name ':#{handler_name}' is defined more than once" if handlers.include?(handler_name)
      raise HandlerActionMustBeSuppliedException, "At least one handler action needs to be supplied to ':#{handler_name}'" if actions.empty?

      handler = class_name.new(options)
      uniq_actions = actions.uniq

      raise HandlerActionAllMustBeSingletonException, "The handler action ':#{:all}' cannot be mixed with other types" if uniq_actions.include?(:all) and uniq_actions.size > 1
      if uniq_actions[0] != :all
        handler.instance_eval { undef :added } unless uniq_actions.include?(:added)
        handler.instance_eval { undef :modified } unless uniq_actions.include?(:modified)
        handler.instance_eval { undef :removed } unless uniq_actions.include?(:removed)
      end

      handlers[handler_name] = handler
    end

    def handlers
      @handlers ||= {}
    end
  end

end
