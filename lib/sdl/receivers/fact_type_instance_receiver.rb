require 'active_support/inflector'

module SDL
  module Receivers
    ##
    # Receiver for setting the properties of Fact and Type instances
    class FactTypeInstanceReceiver
      attr_accessor :instance

      def initialize(instance)
        @instance = instance

        instance.class.properties(true).each do |property|
          unless property.multi
            # Single valued properties are set by their name
            define_singleton_method property.name do |value = nil, &block|
              instance.send "#{property.name}=", block != nil ? SDL::Receivers::PropertyValueReceiver.new(property).instance_exec(&block) : value
            end
          else
            # Multi-valued properties are added to by their singular name
            define_singleton_method property.name.singularize do |value = nil, &block|
              existing_list = instance.send "#{property.name}"
              new_list_item = property.type.new

              SDL::Receivers.set_value(property.type, new_list_item, value) if value != nil

              new_list_item.receiver.instance_exec(&block) if block != nil

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