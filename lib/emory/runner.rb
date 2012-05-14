require 'listen'
require 'emory/configuration_file'
require 'emory/dsl'

module Emory

  class Runner
    class << self
      def start
        emory_config_file = ConfigurationFile.locate
        emory_config_contents = File.read(emory_config_file)
        config = Emory::Dsl.instance_eval_emoryfile(emory_config_contents, emory_config_file)

        config.teleports.each do |teleport|
          listener = Listen.to(teleport.watched_path)
          listener.ignore(teleport.ignore) unless teleport.ignore.nil?
          listener.filter(teleport.filter) unless teleport.filter.nil?
          listener.change(&get_handler_callback(teleport.handler))
          listener.start(false)
        end

        Thread.current.join
      end

      private

      def get_handler_callback(handler)
        Proc.new do |modified, added, removed|
          trigger_handler_method(modified, handler, :modified)
          trigger_handler_method(added, handler, :added)
          trigger_handler_method(removed, handler, :removed)
        end
      end

      def trigger_handler_method(paths, handler, operation)
        unless paths.empty?
          paths.each { |path| handler.send(operation, path) } if handler.respond_to?(operation)
        end
      end
    end
  end

end
