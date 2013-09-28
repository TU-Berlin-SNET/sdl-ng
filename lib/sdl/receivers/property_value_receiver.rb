module SDL
  module Receivers
    class PropertyValueReceiver
      attr_accessor :property

      def initialize(property)
        @property = property
      end
    end
  end
end