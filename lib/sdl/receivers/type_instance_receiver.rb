##
# Receiver for setting the properties of Type instances
class SDL::Receivers::TypeInstanceReceiver
  attr_accessor :instance

  ##
  # When initialized for a fact or type instance, the receiver creates singleton methods on itself for all
  # properties.
  def initialize(type_instance)
    @instance = type_instance

    type_instance.class.properties(true).each do |property|
      if property.single?
        # There are different ways of setting a single valued property
        # -> Specifying a symbol: "Set the value of this property to the instance referred by the symbol"
        # -> Specifying at least a symbol: "Create a new instance of this type and set its properties to the values"
        define_singleton_method property.name do |*args|
          if property.simple_type?
            type_instance.set_sdl_property property, args[0]
          else
            # Replace all symbols with their type instance
            args.map! {|item| item.is_a?(Symbol) ? refer_or_copy(find_instance!(item)) : item }

            begin
              if(args.count == 1 && args[0].class <= property.type)
                # The first argument refers to a predefined instance of the property type. Set it as value
                type_instance.set_sdl_property property, args[0]
              else
                # The arguments are values for a new instance
                property_type_instance = property.type.new

                property_type_instance.set_sdl_values(*args)

                SDL::Receivers::TypeInstanceReceiver.new(property_type_instance).instance_exec(&block) if block_given?

                type_instance.set_sdl_property property, property_type_instance
              end
            rescue RuntimeError => e
              raise RuntimeError, "Cannot set property '#{property.name}' of Type #{@instance.class.name}: #{e}", e.backtrace
            rescue Exception => e
              raise RuntimeError, e
            end
          end
        end
      else
        # Multi-valued properties are added to by their singular name,
        # e.g. 'browsers' is set by invoking 'browser'
        define_singleton_method property.name.singularize do |*property_values, &block|
          existing_list = type_instance.send property.name

          # If there is just one parameter for a multi-valued property setter
          if property_values.length == 1
            # It could be a symbol, which would resolve to a predefined type instance of the same name
            if property_values[0].is_a?(Symbol)
              predefined_value = refer_or_copy(find_instance(property_values[0]))

              raise "Could not find instance :#{property_values[0]} in predefined #{property.type.name} types" unless predefined_value

              existing_list << predefined_value
            # Or better: it could already be an instance of the type - e.g. when using the implemented #method_mssing
            elsif property_values[0].is_a? property.type
              existing_list << property_values[0]

              property_values[0].parent_index = existing_list.count - 1 unless property_values[0].identifier
            else
              raise "Type #{property_values[0].class} of list item '#{property_values}' is incompatible with list type #{property.type}."
            end
          else
            property_values.map! {|item| item.is_a?(Symbol) ? find_instance!(item) : item }

            new_list_item = property.type.new

            new_list_item.set_sdl_values(*property_values) unless property_values.empty?

            self.class.new(new_list_item).instance_exec(&block) unless block.nil?

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
    instance = find_instance(name.to_sym)

    if (instance)
      refer_or_copy(instance)
    else
      raise Exception.new("I do not know what to do with '#{name}'.")
    end
  end

  def find_instance(symbol)
    instance_key_value_pair = SDL::Base::Type.instances_recursive.find do |key, value|
      key == symbol
    end

    if instance_key_value_pair
      instance_key_value_pair[1]
    else
      nil
    end
  end

  def find_instance!(symbol)
    instance = find_instance(symbol)

    instance ? instance : raise("Cannot find predefined instance #{symbol.to_s}!")
  end

  def refer_or_copy(instance)
    instance
  end
end