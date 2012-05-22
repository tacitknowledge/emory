module Emory
  module Handlers

    class AbstractHandler

      attr_reader :name

      def initialize(name, options = {})
        self.name = name
      end

      def added(file_path = nil)
        raise_not_implemented_error(self.class, __method__)
      end

      def modified(file_path = nil)
        raise_not_implemented_error(self.class, __method__)
      end

      def removed(file_path = nil)
        raise_not_implemented_error(self.class, __method__)
      end

      private

      attr_writer :name

      def raise_not_implemented_error(class_name, method_name)
        raise NotImplementedError, "This method is not implemented: #{class_name}##{method_name}"
      end

    end

  end
end
