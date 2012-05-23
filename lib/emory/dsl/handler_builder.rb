module Emory

  class HandlerConfigurationBlockMustBeSuppliedException < Exception; end
  class HandlerNameMustBeSuppliedException < Exception; end
  class HandlerImplementationMustBeSuppliedException < Exception; end
  class HandlerActionAllMustBeSingletonException < Exception; end
  class HandlerActionMustBeSuppliedException < Exception; end
  class HandlerActionUnsupportedException < Exception; end

  class HandlerBuilder

    LOGGER = Logging.logger[self]
    HANDLER_ACTION_ALL = :all
    ALLOWED_HANDLER_ACTIONS = [HANDLER_ACTION_ALL, :added, :modified, :removed]

    def initialize(&block)
      LOGGER.debug('Initializing a new handler builder')
      raise HandlerConfigurationBlockMustBeSuppliedException, "The configuration block with handler settings must be supplied" unless block_given?
      @block = block
      @options = {}
    end

    def build
      LOGGER.debug('Evaluating handler configuration')
      instance_eval &@block

      raise HandlerNameMustBeSuppliedException, "The handler name must be supplied in its configuration" if @name.nil?
      raise HandlerImplementationMustBeSuppliedException, "The handler implementation must be supplied in its configuration" if @implementation.nil?

      LOGGER.debug('Creating a new handler instance')
      beam = @implementation.new(@name, @options)

      raise HandlerActionMustBeSuppliedException, "At least one handler action needs to be supplied" if @events.nil?
      if @events.first != HANDLER_ACTION_ALL
        beam.instance_eval { undef :added } unless @events.include?(:added)
        beam.instance_eval { undef :modified } unless @events.include?(:modified)
        beam.instance_eval { undef :removed } unless @events.include?(:removed)
      end

      beam
    end

    private

    def name(name)
      LOGGER.debug('Setting handler\'s name')
      @name = name
    end

    def implementation(impl)
      LOGGER.debug('Setting handler\'s implementation')
      @implementation = impl
    end

    def options(opts)
      LOGGER.debug('Setting handler\'s options')
      @options = opts
    end

    def events(*actions)
      LOGGER.debug('Setting handler\'s events')
      uniq_actions = actions.uniq

      raise HandlerActionMustBeSuppliedException, "At least one handler action needs to be supplied" if actions.empty?
      raise HandlerActionAllMustBeSingletonException, "The handler action ':#{HANDLER_ACTION_ALL}' cannot be mixed with other types" if uniq_actions.include?(HANDLER_ACTION_ALL) and uniq_actions.size > 1
      uniq_actions.each do |action|
        raise HandlerActionUnsupportedException,
              "The action ':#{action}' is unsupported. Supported actions are #{ALLOWED_HANDLER_ACTIONS}." unless ALLOWED_HANDLER_ACTIONS.include?(action)
      end

      @events = uniq_actions
    end

  end

end
