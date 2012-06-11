require 'spec_helper'
require 'emory/dsl/teleport_config_builder'

module Emory
  module DSL

    describe TeleportConfigBuilder do

      it "mandates handlers and a block need to be supplied to builder constructor" do
        proc {
          TeleportConfigBuilder.new({})
        }.should raise_error(TeleportConfigurationBlockMustBeSuppliedException)
      end

      it "mandates a handler reference to be supplied" do
        p = proc {}

        handlers = {:test_handler => Object.new}
        builder = TeleportConfigBuilder.new(handlers, &p)
        proc {
          builder.build
        }.should raise_error(HandlerReferenceMustBeSuppliedException)
      end

      it "mandates an existing handler reference to be supplied" do
        p = proc {
          handler :does_not_exist
        }

        handlers = {:test_handler => Object.new}
        builder = TeleportConfigBuilder.new(handlers, &p)
        proc {
          builder.build
        }.should raise_error(UndefinedTeleportHandlerException)
      end

      it "mandates a watched path to be supplied" do
        p = proc {
          handler :test_handler
        }

        handlers = {:test_handler => Object.new}
        builder = TeleportConfigBuilder.new(handlers, &p)
        proc {
          builder.build
        }.should raise_error(WatchedPathMustBeSuppliedException)
      end

      it "verifies mandatory configuration settings" do
        p = proc {
          handler :test_handler
          path '/path/to/file'
        }

        handler = Object.new
        handlers = {:test_handler => handler}
        builder = TeleportConfigBuilder.new(handlers, &p)

        teleport = builder.build
        teleport.watched_path.should == '/path/to/file'
        teleport.handler.should == handler
      end

      it "verifies complete configuration settings" do
        p = proc {
          handler :test_handler
          path '/path/to/file'
          ignore %r{ignored/}
          filter /\.txt$/
        }

        handler = Object.new
        handlers = {:test_handler => handler}
        builder = TeleportConfigBuilder.new(handlers, &p)

        teleport = builder.build
        teleport.watched_path.should == '/path/to/file'
        teleport.handler.should == handler
        teleport.ignore.should == %r{ignored/}
        teleport.filter.should == /\.txt$/
      end

      it "verifies optional 'ignore' configuration setting" do
        p = proc {
          handler :test_handler
          path '/path/to/file'
          ignore %r{ignored/}
        }

        handler = Object.new
        handlers = {:test_handler => handler}
        builder = TeleportConfigBuilder.new(handlers, &p)

        teleport = builder.build
        teleport.ignore.should == %r{ignored/}
      end

      it "verifies optional 'filter' configuration setting" do
        p = proc {
          handler :test_handler
          path '/path/to/file'
          filter /\.txt$/
        }

        handler = Object.new
        handlers = {:test_handler => handler}
        builder = TeleportConfigBuilder.new(handlers, &p)

        teleport = builder.build
        teleport.filter.should == /\.txt$/
      end

    end

  end
end
