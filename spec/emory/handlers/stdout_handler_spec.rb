require 'spec_helper'
require 'emory/handlers/stdout_handler'

module Emory
  module Handlers

    describe StdoutHandler do
      context "works with standard output" do
        before(:each) do
          @handler = StdoutHandler.new
        end

        it "'added' just calls 'puts' with right params" do
          @handler.stub!(:puts)
          @handler.should_receive(:puts).with("The file '/path/to/file' was 'added'")
          @handler.added '/path/to/file'
        end

        it "'modified' just calls 'puts' with right params" do
          @handler.stub!(:puts)
          @handler.should_receive(:puts).with("The file '/path/to/file' was 'modified'")
          @handler.modified '/path/to/file'
        end

        it "'deleted' just calls 'puts' with right params" do
          @handler.stub!(:puts)
          @handler.should_receive(:puts).with("The file '/path/to/file' was 'deleted'")
          @handler.deleted '/path/to/file'
        end
      end
    end

  end
end
