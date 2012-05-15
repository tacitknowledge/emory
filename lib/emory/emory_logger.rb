require 'logging'

module Emory
  
  LOG_FILE = 'emory.log'
  
  class Logger
    
    Logging.appenders.stdout(:level => :info)
    Logging.appenders.rolling_file(LOG_FILE, :level => :debug)
    
    Logging.logger.root.add_appenders(:stdout, LOG_FILE)
    
    attr_reader :log
    
    def initialize(object)
      @log = Logging.logger[object.name]
    end
    
    class << self
      
      def for object
        new(object).log
      end
      
    end
  end
end