require 'spec_helper'
require 'listen'
require 'pathname'
require 'emory/runner'
require 'emory/dsl/dsl'
require 'emory/teleport_config'
require 'emory/handlers/stdout_handler'

module Emory

  describe Runner do
    context "class object" do
      it "starts the config file location process, creates necessary listener with absolute path and joins current thread" do
        dsl = DSL::Dsl.new
        teleport = TeleportConfig.new
        teleport.watched_path = 'watched_path'
        teleport.handler = Handlers::StdoutHandler.new(:handler_name)
        teleport.ignore = 'ignore_path'
        teleport.filter = 'filter_expression'
        dsl.teleports << teleport

        path_to_config_file = '/path/to/config/file'
        ConfigurationFile.stub(:locate => path_to_config_file)
        File.stub(:read).with(path_to_config_file).and_return('contents')
        DSL::Dsl.stub(:instance_eval_emoryfile).with('contents', path_to_config_file).and_return(dsl)

        Pathname.any_instance.stub(:absolute?).and_return(true)

        mock_listener = double("listener")
        Listen.stub(:to).with('watched_path').and_return(mock_listener)
        mock_listener.should_receive(:ignore).with(teleport.ignore)
        mock_listener.should_receive(:filter).with(teleport.filter)
        mock_listener.should_receive(:change)
        mock_listener.should_receive(:start).with(false)

        Thread.should_receive(:stop).once

        Runner.start
      end

      it "starts the config file location process, creates necessary listener with relative path and joins current thread" do
        dsl = DSL::Dsl.new
        teleport = TeleportConfig.new
        teleport.watched_path = 'watched_path'
        teleport.handler = Handlers::StdoutHandler.new(:handler_name)
        teleport.ignore = 'ignore_path'
        teleport.filter = 'filter_expression'
        dsl.teleports << teleport

        path_to_config_file = '/path/to/config/file'
        ConfigurationFile.stub(:locate => path_to_config_file)
        File.stub(:read).with(path_to_config_file).and_return('contents')
        DSL::Dsl.stub(:instance_eval_emoryfile).with('contents', path_to_config_file).and_return(dsl)

        Pathname.any_instance.stub(:absolute?).and_return(false)
        File.should_receive(:expand_path).with('watched_path', '/path/to/config').and_return('/path/to/config/watched_path')

        mock_listener = double("listener")
        Listen.stub(:to).with('/path/to/config/watched_path').and_return(mock_listener)
        mock_listener.should_receive(:ignore).with(teleport.ignore)
        mock_listener.should_receive(:filter).with(teleport.filter)
        mock_listener.should_receive(:change)
        mock_listener.should_receive(:start).with(false)

        Thread.should_receive(:stop).once

        Runner.start
      end
    end
  end
end
