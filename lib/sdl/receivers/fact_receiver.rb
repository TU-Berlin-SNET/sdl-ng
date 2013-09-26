require_relative 'property_definitions'

module SDL
  module Receivers
    class FactReceiver
      include ActiveSupport::Inflector
      include PropertyDefinitions

      attr :fact_class
      attr :fact_classes

      define_properties_for :fact_class

      def initialize(sym, superclass = nil)
        @fact_class = Class.new(superclass || SDL::Base::Fact)
        @fact_class.local_name = sym.to_s.camelize

        @fact_classes = [@fact_class]
      end

      def better(sym)

      end

      def subfact(sym, &fact_type_definition)
        receiver = FactReceiver.new(sym, fact_class)
        receiver.instance_eval(&fact_type_definition) if block_given?

        fact_classes.concat(receiver.fact_classes)
      end
    end
  end
end