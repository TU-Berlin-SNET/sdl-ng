require_relative 'receivers/type_instance_receiver'
require_relative 'receivers/type_receiver'
require_relative 'receivers/fact_receiver'
require_relative 'receivers/property_receiver'
require_relative 'receivers/property_value_receiver'
require_relative 'receivers/service_receiver'


module SDL
  module Receivers
    # If a value is given, search for all Fact or Type ancestor classes until a
    # property is found, which has the same name as its class. Set it using its receiver.
    def self.set_value(klass, instance, value, compendium)
      klass.ancestors.each do |ancestor_class|
        break if ancestor_class.eql?(SDL::Base::Fact) || ancestor_class.eql?(SDL::Base::Type)

        ancestor_class.properties.each do |property|
          if property.name.eql? ancestor_class.local_name.underscore
            TypeInstanceReceiver.new(instance, compendium).send("#{ancestor_class.local_name.underscore}", value)

            return
          end
        end
      end

      raise "I didn't know what property of class #{klass.local_name} to set to value #{value}."
    end
  end
end