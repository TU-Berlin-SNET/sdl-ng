module SDL::Receivers
  class Receiver
    attr :compendium

    def initialize(compendium)
      @compendium = compendium
    end

    def set_value(type_class, type_instance, *property_values)
      property_values.zip(type_class.properties(true)).each do |value, property|
        if(value.is_a?(Hash))
          TypeInstanceReceiver.new(type_instance, @compendium).send(value.keys.first.to_s, value.values.first)
        else
          raise "Specified value '#{value}' for non-existing property." unless property

          TypeInstanceReceiver.new(type_instance, @compendium).send(property.name, value)
        end
      end
    end
  end
end