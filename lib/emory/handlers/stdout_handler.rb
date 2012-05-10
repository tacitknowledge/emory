require 'emory/handlers/abstract_handler'

module Emory
  module Handlers

    class StdoutHandler < AbstractHandler

      def added(file_path)
        report_file_path_action(file_path, __method__)
      end

      def modified(file_path)
        report_file_path_action(file_path, __method__)
      end

      def deleted(file_path)
        report_file_path_action(file_path, __method__)
      end

      private

      def report_file_path_action(file_path, action)
        puts "The file '#{file_path}' was '#{action}'"
      end

    end

  end
end