require 'active_support/inflector'

module SDL
  module Receivers
    ##
    # Receiver for setting the properties of Fact and Type instances
    class FactTypeInstanceReceiver
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

              instance.send "#{property.name}=", block != nil ? SDL::Receivers::PropertyValueReceiver.new(property).instance_exec(&block) : value
            end
          else
            # Multi-valued properties are added to by their singular name
            define_singleton_method property.name.singularize do |value = nil, &block|
              existing_list = instance.send "#{property.name}"
              new_list_item = property.type.new

              if value != nil
                SDL::Receivers.set_value(property.type, new_list_item, value, @compendium)
              end
              if block != nil
                self.class.new(new_list_item, @compendium).instance_exec(&block)
              end

              existing_list << new_list_item
            end
          end
        end
      end

      def self.const_missing(name)
        puts name
      end
    end
  end
end