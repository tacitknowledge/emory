require 'spec_helper'
require 'emory/dsl/dsl'
require 'emory/dsl/handler_builder'
require 'emory/dsl/teleport_config_builder'
require 'emory/handlers/abstract_handler'

module Emory
  module DSL

    describe Dsl do
      let(:dsl) { Dsl.new }

      context "class object" do
        it "parses the supplied teleport config and configures correct object types in frozen collections" do
          contents = <<-EOM
          require 'emory/handlers/abstract_handler'

          handler do
            name :something
            implementation Emory::Handlers::AbstractHandler
            events :all
          end

          teleport do
            path '/path/to/dir'
            handler :something
          end
          EOM

          config = Dsl.instance_eval_emoryfile(contents, '/path/to/file')
          config.should have(1).handlers
          config.handlers.should be_frozen
          config.handlers[:something].class.should == Emory::Handlers::AbstractHandler
          config.should have(1).teleports
          config.teleports.should be_frozen
          config.teleports[0].class.should == Emory::TeleportConfig
        end

        it "detects and reports incorrect usage of DSL" do
          contents = <<-EOM
          blah_blah_blah
          EOM

          proc {
            Dsl.instance_eval_emoryfile(contents, '/path/to/file')
          }.should raise_error(EmoryMisconfigurationException,
                               /Incorrect contents of .emory file/)
        end
      end

      context "'handler' method" do
        it "does not allow to add multiple handlers with the same name" do
          dsl.handlers[:something] = Object.new
          builder = double('handler_builder')
          handler = double('handler')
          HandlerBuilder.should_receive(:new).and_return(builder)
          builder.should_receive(:build).and_return(handler)
          handler.should_receive(:name).twice.and_return(:something)

          proc {
            dsl.handler {}
          }.should raise_error(DuplicateHandlerNameException)
        end

        it "adds a handler to its list" do
          builder = double('handler_builder')
          handler = double('handler')
          HandlerBuilder.should_receive(:new).and_return(builder)
          builder.should_receive(:build).and_return(handler)
          handler.should_receive(:name).exactly(3).times.and_return(:something)

          dsl.handler {}
          dsl.should have(1).handlers
        end
      end

      context "'teleport' method" do
        it "adds a teleport to its list" do
          builder = double('teleport_builder')
          teleport = double('teleport')
          TeleportConfigBuilder.should_receive(:new).and_return(builder)
          builder.should_receive(:build).and_return(teleport)

          dsl.teleport {}
          dsl.should have(1).teleports
        end
      end
    end

  end
end
