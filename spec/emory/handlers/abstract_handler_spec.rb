require 'spec_helper'
require 'emory/handlers/abstract_handler'

module Emory
  module Handlers

    describe AbstractHandler do
      context "is abstract so its method" do
        before(:each) do
          @handler = AbstractHandler.new
        end

        it "'added' raises NotImplementedError" do
          proc {
            @handler.added
          }.should raise_error(NotImplementedError,
                               /This method is not implemented: Emory::Handlers::AbstractHandler#added/)
        end

        it "'modified' raises NotImplementedError" do
          proc {
            @handler.modified
          }.should raise_error(NotImplementedError,
                               /This method is not implemented: Emory::Handlers::AbstractHandler#modified/)
        end

        it "'deleted' raises NotImplementedError" do
          proc {
            @handler.deleted
          }.should raise_error(NotImplementedError,
                               /This method is not implemented: Emory::Handlers::AbstractHandler#deleted/)
        end
      end
    end

  end
end
