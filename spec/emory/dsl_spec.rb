require 'spec_helper'
require 'emory/dsl'
require 'emory/handler_builder'
require 'emory/handlers/abstract_handler'

module Emory

  describe Dsl do
    let(:dsl) { Dsl.new }

    context "class object" do
      it "parses the supplied handler config and configures correct object types in frozen collections" do
        contents = <<-EOM
          require 'emory/handlers/abstract_handler'

          handler do
            name :something
            implementation Emory::Handlers::AbstractHandler
            events :all
          end

          teleport '/path/to/dir', :something, ignore: %r{ignored/}, filter: /\.txt$/
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
    end

    context "'teleport' method" do
      it "mandates referenced handlers must exist at the configuration time" do
        proc {
          dsl.teleport(nil, :something)
        }.should raise_error(UndefinedTeleportHandlerException,
                             /The handler ':something' wired to teleport could not be found/)
      end

      it "configures the teleport config with mandatory data" do
        handler = Object.new
        dsl.handlers[:something] = handler
        dsl.teleport('/path/to/dir', :something)
        dsl.should have(1).teleports
        dsl.teleports[0].watched_path.should == '/path/to/dir'
        dsl.teleports[0].filter.should be_nil
        dsl.teleports[0].ignore.should be_nil
      end

      it "configures the teleport config with optional data" do
        handler = Object.new
        dsl.handlers[:something] = handler
        dsl.teleport('/path/to/dir', :something, ignore: %r{ignored/}, filter: /\.txt$/)
        dsl.should have(1).teleports
        dsl.teleports[0].watched_path.should == '/path/to/dir'
        dsl.teleports[0].filter.should == /\.txt$/
        dsl.teleports[0].ignore.should == %r{ignored/}
      end
    end
  end

end
