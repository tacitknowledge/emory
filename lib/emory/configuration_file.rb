module Emory

  class ConfigurationFile
    class << self
      CONFIG_FILE_NAME = ".emory"
      
      def read
        file = get_file Dir.pwd, CONFIG_FILE_NAME
        if file.nil?
          puts "configuration file NOT found"
        else
          # TODO: raise error
          puts "configuration file found: #{file}"
        end
      end
      
      private
      
      def get_file dir, file_name
        puts "Start to search for configuration file: #{file_name}"
        begin
          puts "Searching for configuration file under: #{dir}"
          file = get_file_full_path dir, file_name
          break unless file.nil?
          dir = get_parent_directory dir
        end until dir == '/'
        file
      end
      
      def get_parent_directory dir
        File.expand_path("..", dir)
      end
      
      def file_exists? dir, file
        File.exists?(File.expand_path(file, dir))
      end
      
      def get_file_full_path dir, file
        File.expand_path(file, dir) if file_exists?(dir, file)
      end
    end
  end

end
