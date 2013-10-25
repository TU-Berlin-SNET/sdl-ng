require_relative 'receivers/type_instance_receiver'
require_relative 'receivers/type_receiver'
require_relative 'receivers/fact_receiver'
require_relative 'receivers/service_receiver'


module SDL
  module Receivers
    #
    def self.set_value(type_class, type_instance, *property_values, compendium)
      property_values.zip(type_class.properties(true)).each do |value, property|
        raise "Specified value '#{value}' for non-existing property." unless property

        if(value.is_a?(Hash))
          TypeInstanceReceiver.new(type_instance, compendium).send(value.keys.first.to_s, value.values.first)
        else
          TypeInstanceReceiver.new(type_instance, compendium).send(property.name, value)
        end
      end
    end
  end
end