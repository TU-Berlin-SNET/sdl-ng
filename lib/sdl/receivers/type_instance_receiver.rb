##
# Receiver for setting the properties of Type instances
class SDL::Receivers::TypeInstanceReceiver < SDL::Receivers::Receiver
  attr_accessor :instance

  ##
  # When initialized for a fact or type instance, the receiver creates singleton methods on itself for all
  # properties.
  def initialize(type_instance, compendium)
    super(compendium)

    @instance = type_instance

    type_instance.class.properties(true).each do |property|
      if property.single?
        # Single valued properties are set by their name
        define_singleton_method property.name do |value = nil, &block|
          if value.is_a? Symbol
            value = compendium.type_instances[property.type][value] || raise("Could not find instance :#{value.to_s} in predefined #{property.type.name} types")
          end

          begin
            type_instance.send "#{property.name}=", value
          rescue RuntimeError => e
            raise RuntimeError, "Cannot set property '#{property.name}' of Type #{@instance.class.name}: #{e}", e.backtrace
          end
        end
      else
        # Multi-valued properties are added to by their singular name, e.g. 'browsers' is set by invoking 'browser'
        define_singleton_method property.name.singularize do |*property_values, &block|
          existing_list = type_instance.send "#{property.name}"

          # If there is just one parameter for a multi-valued property setter
          if property_values.length == 1
            # It could be a symbol, which would resolve to a predefined type instance of the same name
            if property_values[0].is_a?(Symbol)
              predefined_value = compendium.type_instances[property.type][property_values[0]]

              raise "Could not find instance :#{property_values[0]} in predefined #{property.type.name} types" unless predefined_value

              existing_list << compendium.type_instances[property.type][property_values[0]]
            # Or better: it could already be an instance of the type - e.g. when using the implemented #method_mssing
            elsif property_values[0].is_a? property.type
              existing_list << property_values[0]

              property_values[0].parent_index = existing_list.count - 1 unless property_values[0].identifier
            else
              raise "Type #{property_values[0].class} of list item '#{property_values}' is incompatible with list type #{property.type}."
            end
          else
            new_list_item = property.type.new

            set_value(property.type, new_list_item, *property_values)

            SDL::Receivers::TypeInstanceReceiver.new(new_list_item, @compendium).instance_exec(&block) unless block.nil?

            existing_list << new_list_item

            new_list_item.parent = type_instance
            new_list_item.parent_index = existing_list.count - 1
          end
        end
      end
    end
  end

  def annotation(value)
    @instance.annotations << value
  end

  ##
  # Catches calls to methods named similarily to possible predefined type instances
  def method_missing(name, *args)
    # Possible type instances are all types of properties of properties of this instance ...
    possible_type_classes = @instance.class.properties.map(&:type).map(&:properties).flatten.map(&:type).select{|type| type.wrapped_type < SDL::Base::Type}

    # ... and the types of multi-value instances
    possible_type_classes.concat(@instance.class.properties.find_all{|p| p.multi?}.map(&:type))

    possible_type_instances = @compendium.type_instances.select{|k, v| possible_type_classes.include?(k)}.map{|k, v| v[name]}.select{|v| v != nil}

    unless possible_type_instances.nil? || possible_type_instances.empty?
      possible_type_instances[0]
    else
      raise Exception.new("I do not know what to do with '#{name}' in #{caller[0]}")
    end
  end
end