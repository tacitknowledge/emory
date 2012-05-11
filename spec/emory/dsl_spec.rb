require 'spec_helper'
require 'emory/dsl'
require 'emory/handlers/abstract_handler'

module Emory

  describe Dsl do
    context "class object" do
      it "parses the supplied handler config and configures correct object type" do
        contents = <<-EOM
          require 'emory/handlers/abstract_handler'
          handler :something, Emory::Handlers::AbstractHandler, {}, :all
        EOM

        config = Dsl.instance_eval_emoryfile(contents, '/path/to/file')
        config.handlers.size.should == 1
        config.handlers[:something].class.should == Emory::Handlers::AbstractHandler
      end

      it "detects and reports incorrect usage of DSL" do
        contents = <<-EOM
          blah_blah_blah
        EOM

        Dsl.stub!(:puts)
        Dsl.should_receive(:puts).with(/Incorrect contents of .emory file, original error is:\n/)

        proc {
          Dsl.instance_eval_emoryfile(contents, '/path/to/file')
        }.should raise_error(EmoryMisconfigurationException,
                             /Incorrect contents of .emory file/)
      end
    end

    context "'handler' method" do
      before(:each) do
        @dsl = Dsl.new
      end

      it "passes the supplied options on to the handler's contructor" do
        options = {host: 'localhost', port: '8080'}
        Emory::Handlers::AbstractHandler.should_receive(:new).with(options)
        @dsl.handler(:something, Emory::Handlers::AbstractHandler, options, :all)
      end

      it "does not allow to add multiple handlers with the same name" do
        @dsl.handlers[:something] = Object.new
        proc {
          @dsl.handler(:something, nil, nil)
        }.should raise_error(DuplicateHandlerNameException,
                             /The handler name ':something' is defined more than once/)
      end

      it "mandates action of type ':all' to be exclusive of other types" do
        proc {
          @dsl.handler(:something, Emory::Handlers::AbstractHandler, {}, :added, :all)
        }.should raise_error(HandlerActionAllMustBeSingletonException,
                             /The handler action ':all' cannot be mixed with other types/)
      end

      it "mandates at least one action type to be supplied" do
        proc {
          @dsl.handler(:something, Emory::Handlers::AbstractHandler, {})
        }.should raise_error(HandlerActionMustBeSuppliedException,
                             /At least one handler action needs to be supplied to ':something'/)
      end

      it "mandates correct handler action types are allowed to be supplied" do
        proc {
          @dsl.handler(:something, Emory::Handlers::AbstractHandler, {}, :foo)
        }.should raise_error(HandlerActionUnsupportedException,
                             /The action ':foo' supplied to handler ':something' is unsupported./)
      end

      it "with action of type ':all' does not undefine any handler's methods" do
        @dsl.handler(:something, Emory::Handlers::AbstractHandler, {}, :all)
        @dsl.handlers[:something].respond_to?(:added).should == true
        @dsl.handlers[:something].respond_to?(:modified).should == true
        @dsl.handlers[:something].respond_to?(:removed).should == true
      end

      it "with all action types does not undefine any handler's methods" do
        @dsl.handler(:something, Emory::Handlers::AbstractHandler, {}, :added, :modified, :removed)
        @dsl.handlers[:something].respond_to?(:added).should == true
        @dsl.handlers[:something].respond_to?(:modified).should == true
        @dsl.handlers[:something].respond_to?(:removed).should == true
      end

      it "undefines handler's methods which are not supplied" do
        @dsl.handler(:something, Emory::Handlers::AbstractHandler, {}, :added)
        @dsl.handlers[:something].respond_to?(:added).should == true
        @dsl.handlers[:something].respond_to?(:modified).should == false
        @dsl.handlers[:something].respond_to?(:removed).should == false
      end
    end

    context "'teleport' method" do
      before(:each) do
        @dsl = Dsl.new
      end

      it "mandates referenced handlers must exist at the configuration time" do
        proc {
          @dsl.teleport(nil, :something)
        }.should raise_error(UndefinedTeleportHandlerException,
                             /The handler ':something' wired to teleport could not be found/)
      end

      it "configures the teleport config with mandatory data" do
        handler = Object.new
        @dsl.handlers[:something] = handler
        @dsl.teleport('/path/to/dir', :something)
        @dsl.teleports.size.should == 1
        @dsl.teleports[0].watched_path.should == '/path/to/dir'
        @dsl.teleports[0].filter.should be_nil
        @dsl.teleports[0].ignore.should be_nil
      end

      it "configures the teleport config with optional data" do
        handler = Object.new
        @dsl.handlers[:something] = handler
        @dsl.teleport('/path/to/dir', :something, ignore: %r{ignored/}, filter: /\.txt$/)
        @dsl.teleports.size.should == 1
        @dsl.teleports[0].watched_path.should == '/path/to/dir'
        @dsl.teleports[0].filter.should == /\.txt$/
        @dsl.teleports[0].ignore.should == %r{ignored/}
      end
    end
  end

end
