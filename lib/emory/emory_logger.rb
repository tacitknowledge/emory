require 'logging'

module Emory
  
  LOG_FILE = 'emory.log'
  
  class Logger
    
    Logging.logger.root.level = :info
    Logging.logger.root.add_appenders(
      Logging.appenders.file(LOG_FILE), Logging.appenders.stdout)
    
    class << self
  
      def for_class name
        logger = Logging.logger[name]
      end
  
    end
  end
end