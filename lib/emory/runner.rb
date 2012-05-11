require 'emory/configuration_file'
require 'emory/dsl'

module Emory

  class Runner
    class << self
      def start
        emory_config_file = ConfigurationFile.locate
        emory_config_contents = File.read(emory_config_file)
        Emory::Dsl.instance_eval_emoryfile(emory_config_contents, emory_config_file)
      end
    end
  end

end
