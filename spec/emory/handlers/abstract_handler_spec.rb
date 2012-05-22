require 'spec_helper'
require 'emory/handlers/abstract_handler'

module Emory
  module Handlers

    describe AbstractHandler do
      context "is abstract so its method" do
        let(:handler) { AbstractHandler.new(:test_handler) }

        it "'added' raises NotImplementedError" do
          proc {
            handler.added
          }.should raise_error(NotImplementedError,
                               /This method is not implemented: Emory::Handlers::AbstractHandler#added/)
        end

        it "'modified' raises NotImplementedError" do
          proc {
            handler.modified
          }.should raise_error(NotImplementedError,
                               /This method is not implemented: Emory::Handlers::AbstractHandler#modified/)
        end

        it "'removed' raises NotImplementedError" do
          proc {
            handler.removed
          }.should raise_error(NotImplementedError,
                               /This method is not implemented: Emory::Handlers::AbstractHandler#removed/)
        end
      end
    end

  end
end
