require 'active_support/inflector'

module SDL
  module Receivers
    ##
    # Receiver for setting the properties of Type instances
    class TypeInstanceReceiver
      attr_accessor :instance

      attr_accessor :compendium

      ##
      # When initialized for a fact or type instance, the receiver creates singleton methods on itself for all
      # properties.
      def initialize(instance, compendium)
        @instance = instance
        @compendium = compendium

        instance.class.properties(true).each do |property|
          if property.single?
            # Single valued properties are set by their name
            define_singleton_method property.name do |value = nil, &block|
              value = compendium.type_instances[property.type][value] if value.is_a? Symbol

              instance.send "#{property.name}=", value
            end
          else
            # Multi-valued properties are added to by their singular name
            define_singleton_method property.name.singularize do |*property_values, &block|
              existing_list = instance.send "#{property.name}"

              unless property_values.empty?
                if property_values.length == 1 && property_values[0].is_a?(Symbol)
                  predefined_value = compendium.type_instances[property.type][property_values[0]]

                  raise "Could not find instance :#{property_values[0]} in predefined #{property.type.name} types" unless predefined_value

                  existing_list << compendium.type_instances[property.type][property_values[0]]
                else
                  new_list_item = property.type.new

                  SDL::Receivers.set_value(property.type, new_list_item, *property_values, @compendium)

                  self.class.new(new_list_item, @compendium).instance_exec(&block) unless block.nil?

                  existing_list << new_list_item
                end
              end
            end
          end
        end
      end

      def annotation(value)
        @instance.annotations << value
      end
    end
  end
end