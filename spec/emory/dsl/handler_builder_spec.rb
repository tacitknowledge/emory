require 'spec_helper'
require 'emory/handler_builder'
require 'emory/handlers/stdout_handler'

module Emory
  describe HandlerBuilder do

    it "mandates a block needs to be supplied to builder constructor" do
      proc {
        HandlerBuilder.new
      }.should raise_error(HandlerConfigurationBlockMustBeSuppliedException)
    end

    it "mandates action of type ':all' to be exclusive of other types" do
      p = proc {
        name :test_handler
        implementation ::Emory::Handlers::StdoutHandler
        events :added, :all
      }

      builder = HandlerBuilder.new(&p)
      proc {
        builder.build
      }.should raise_error(HandlerActionAllMustBeSingletonException)
    end

    it "mandates at least one action type to be supplied to 'events'" do
      p = proc {
        name :test_handler
        implementation ::Emory::Handlers::StdoutHandler
        events
      }

      builder = HandlerBuilder.new(&p)
      proc {
        builder.build
      }.should raise_error(HandlerActionMustBeSuppliedException)
    end

    it "mandates 'events' configuration to be supplied to proc" do
      p = proc {
        name :test_handler
        implementation ::Emory::Handlers::StdoutHandler
      }

      builder = HandlerBuilder.new(&p)
      proc {
        builder.build
      }.should raise_error(HandlerActionMustBeSuppliedException)
    end

    it "mandates correct handler action types are required to be supplied" do
      p = proc {
        name :test_handler
        implementation ::Emory::Handlers::StdoutHandler
        events :foo
      }

      builder = HandlerBuilder.new(&p)
      proc {
        builder.build
      }.should raise_error(HandlerActionUnsupportedException)
    end

    it "mandates 'name' configuration to be supplied to proc" do
      p = proc {
        implementation ::Emory::Handlers::StdoutHandler
      }

      builder = HandlerBuilder.new(&p)
      proc {
        builder.build
      }.should raise_error(HandlerNameMustBeSuppliedException)
    end

    it "mandates 'implementation' configuration to be supplied to proc" do
      p = proc {
        name :test_handler
      }

      builder = HandlerBuilder.new(&p)
      proc {
        builder.build
      }.should raise_error(HandlerImplementationMustBeSuppliedException)
    end

    it "passes the supplied name and options on to the handler's constructor" do
      p = proc {
        name :test_handler
        implementation ::Emory::Handlers::StdoutHandler
        events :all
        options host: 'localhost', port: '8080'
      }

      Emory::Handlers::StdoutHandler.should_receive(:new).with(:test_handler, {host: 'localhost', port: '8080'})

      builder = HandlerBuilder.new(&p)
      builder.build
    end

    it "passes the supplied name and empty hash on to the handler's constructor if options configuration is not supplied" do
      p = proc {
        name :test_handler
        implementation ::Emory::Handlers::StdoutHandler
        events :all
      }

      Emory::Handlers::StdoutHandler.should_receive(:new).with(:test_handler, {})

      builder = HandlerBuilder.new(&p)
      builder.build
    end

    it "with action of type ':all' does not undefine any handler's methods" do
      p = proc {
        name :test_handler
        implementation ::Emory::Handlers::StdoutHandler
        events :all
      }

      builder = HandlerBuilder.new(&p)
      handler = builder.build

      handler.respond_to?(:added).should == true
      handler.respond_to?(:modified).should == true
      handler.respond_to?(:removed).should == true
    end

    it "with all action types does not undefine any handler's methods" do
      p = proc {
        name :test_handler
        implementation ::Emory::Handlers::StdoutHandler
        events :added, :modified, :removed
      }

      builder = HandlerBuilder.new(&p)
      handler = builder.build

      handler.respond_to?(:added).should == true
      handler.respond_to?(:modified).should == true
      handler.respond_to?(:removed).should == true
    end

    it "undefines handler's methods which are not supplied" do
      p = proc {
        name :test_handler
        implementation ::Emory::Handlers::StdoutHandler
        events :added
      }

      builder = HandlerBuilder.new(&p)
      handler = builder.build

      handler.respond_to?(:added).should == true
      handler.respond_to?(:modified).should == false
      handler.respond_to?(:removed).should == false
    end

  end
end
