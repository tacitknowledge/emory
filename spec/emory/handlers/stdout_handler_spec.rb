require 'spec_helper'
require 'emory/handlers/stdout_handler'

module Emory
  module Handlers

    describe StdoutHandler do
      context "works with standard output" do
        let(:handler) { StdoutHandler.new(:test_handler) }

        it "'added' just calls 'puts' with right params" do
          handler.should_receive(:puts).with("The file '/path/to/file' was 'added'")
          handler.added '/path/to/file'
        end

        it "'modified' just calls 'puts' with right params" do
          handler.should_receive(:puts).with("The file '/path/to/file' was 'modified'")
          handler.modified '/path/to/file'
        end

        it "'removed' just calls 'puts' with right params" do
          handler.should_receive(:puts).with("The file '/path/to/file' was 'removed'")
          handler.removed '/path/to/file'
        end
      end
    end

  end
end
