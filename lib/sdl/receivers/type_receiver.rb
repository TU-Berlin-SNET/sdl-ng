module SDL
  module Receivers
    class TypeReceiver
      include ActiveSupport::Inflector
      include PropertyDefinitions

      define_attributes_for :type_class

      attr :type_class

      def initialize(sym)
        @type_class = Class.new(SDL::Base::Type)
        @type_class.local_name = sym.to_s.camelize
      end
    end
  end
end