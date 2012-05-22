require 'listen'
require 'spec_helper'
require 'emory/runner'
require 'emory/dsl'
require 'emory/teleport_config'
require 'emory/handlers/stdout_handler'

module Emory

  describe Runner do
    context "class object" do
      it "starts the config file location process, creates necessary listeners and joins current thread" do
        dsl = Dsl.new
        teleport = TeleportConfig.new
        teleport.watched_path = 'watched_path'
        teleport.handler = Handlers::StdoutHandler.new(:handler_name)
        teleport.ignore = 'ignore_path'
        teleport.filter = 'filter_expression'
        dsl.teleports << teleport

        path_to_config_file = '/path/to/config/file'
        ConfigurationFile.stub(:locate => path_to_config_file)
        File.stub(:read).with(path_to_config_file).and_return('contents')
        Dsl.stub(:instance_eval_emoryfile).with('contents', path_to_config_file).and_return(dsl)

        mock_listener = double("listener")
        Listen.stub(:to).with(teleport.watched_path).and_return(mock_listener)
        mock_listener.should_receive(:ignore).with(teleport.ignore)
        mock_listener.should_receive(:filter).with(teleport.filter)
        mock_listener.should_receive(:change)
        mock_listener.should_receive(:start).with(false)

        mock_thread = double("thread")
        Thread.stub(:current => mock_thread)
        mock_thread.should_receive(:join)

        Runner.start
      end
    end
  end
end
