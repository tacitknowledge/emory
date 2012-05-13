require 'logging'

module Emory

  class Logger
    
    Logging.logger.root.level = :info
    Logging.logger.root.add_appenders(
      Logging.appenders.file('emory.log'), Logging.appenders.stdout)
    
    class << self
  
      def for_class name
        logger = Logging.logger[name]
      end
  
    end
  end
end