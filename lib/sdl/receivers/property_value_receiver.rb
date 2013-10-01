module SDL
  module Receivers
    ##
    # Receiver for property values
    class PropertyValueReceiver
      attr_accessor :property

      def initialize(property)
        @property = property
      end
    end
  end
end