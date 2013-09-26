module SDL
  module Receivers
    class TypeReceiver
      include ActiveSupport::Inflector
      include PropertyDefinitions

      define_properties_for :type_class

      attr :type_class

      def initialize(sym)
        @type_class = Class.new(SDL::Base::Type)
        @type_class.local_name = sym.to_s.camelize
        @type_class.class_eval do
          include SDL::Types::SDLType

          wraps self
          codes local_name.underscore.to_sym
        end
      end
    end
  end
end