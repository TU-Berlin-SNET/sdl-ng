module SDL
  module Receivers
    module PropertyDefinitions
      def self.included(base)
        base.class_eval do
          def self.define_attributes_for(sym)
            @target_class = sym
          end
        end
      end

      def list(sym, &property_definition)
        property = SDL::Base::Property.new(sym, Array)

        receiver = PropertyReceiver.new(property)
        receiver.instance_eval &property_definition if block_given?

        target_class.properties << property
      end

      def simple_type(sym, type)
        target_class.class_eval do
          attr_accessor sym

          properties << SDL::Base::Property.new(sym, type)
        end
      end

      def method_missing(name, *args, &block)
        if name =~ /list_of_/ then
          list(args[0], &block)
        elsif SDL::Types.registry[name.to_sym]
          simple_type args[0], SDL::Types.registry[name.to_sym]
        else
          super(name, *args, &block)
        end
      end

      def target_class
        send self.class.instance_variable_get('@target_class')
      end
    end
  end
end