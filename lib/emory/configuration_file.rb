module Emory

  class ConfigurationFile

    CONFIG_FILE_NAME = ".emory"
    START_SEARCH_INFO = "Start to search for configuration file: %s"
    SEARCH_INFO = "Searching for configuration file under: %s"
    FILE_FOUND_INFO = "configuration file found: %s"
    FILE_NOT_FOUND_INFO = "configuration file NOT found"

    class << self
      def locate
        puts START_SEARCH_INFO % CONFIG_FILE_NAME
        file_full_path = locate_file Dir.pwd, CONFIG_FILE_NAME
        if file_full_path.nil?
          raise FILE_NOT_FOUND_INFO
        else
          puts FILE_FOUND_INFO % file_full_path
          file_full_path
        end
      end
      
      private
      
      def locate_file dir, file_name
        file_full_path = get_file_full_path dir, file_name
        while file_full_path.nil?
          dir = get_parent_directory dir
          file_full_path = get_file_full_path dir, file_name
          break if dir == '/'
        end
        file_full_path
      end
      
      def get_parent_directory dir
        File.expand_path("..", dir)
      end
      
      def get_file_full_path dir, file
        puts SEARCH_INFO % dir
        file_full_path = File.expand_path(file, dir)
        if File.exists?(file_full_path)
          file_full_path 
        else
          nil
        end
      end
    end
  end

end
