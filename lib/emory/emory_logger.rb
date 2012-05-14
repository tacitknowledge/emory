require 'logging'

module Emory
  
  LOG_FILE = 'emory.log'
  
  class Logger
    
    Logging.appenders.stdout(:level => :info)
    Logging.appenders.rolling_file(LOG_FILE, :level => :debug)
    
    Logging.logger.root.add_appenders(:stdout, LOG_FILE)
    
    class << self
  
      def for_class name
        Logging.logger[name]
      end
  
    end
  end
end