module SDL
  module Receivers
    class PropertyReceiver
      include ActiveSupport::Inflector

      attr :property

      def initialize(property)
        @property = property
      end

      def type(sym)
        @property.type = sym.to_s.camelize.constantize
      end

      def better(sym)

      end
    end
  end
end