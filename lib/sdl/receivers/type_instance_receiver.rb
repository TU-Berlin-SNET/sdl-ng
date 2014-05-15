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
        define_singleton_method property.name do |*args, &block|
          if property.simple_type?
            type_instance.set_sdl_property property, args[0]

            if args[1]
              type_instance.get_sdl_value(property).annotations << args[1][:annotation]
            end
          else
            # Replace all symbols with their type instance
            args.map! {|item| item.is_a?(Symbol) ? refer_or_copy(find_instance!(item)) : item }

            begin
              if(args.count == 1 && args[0].class <= property.type)
                # The first argument refers to a predefined instance of the property type. Set it as value
                type_instance.set_sdl_property property, refer_or_copy(args[0])
              else
                # The arguments are values for a new instance
                property_type_instance = property.type.new

                property_type_instance.set_sdl_values(*args)

                SDL::Receivers::TypeInstanceReceiver.new(property_type_instance).instance_eval(&block) if block

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
        define_singleton_method property.name.singularize do |*arguments, &block|
          existing_list = type_instance.send property.name

          arguments.map! {|item| item.is_a?(Symbol) ? refer_or_copy(find_instance!(item)) : item }

          if arguments[0].is_a?(property.type)
            # The first argument is the value
            new_item = refer_or_copy(arguments[0])

            arguments.each do |arg|
              if arg.is_a?(Hash) && arg[:annotation]
                new_item.annotations << arg[:annotation]
              end
            end
          else
            if property.simple_type?
              new_item = property.type.new
              new_item.raw_value = arguments[0]

              if arguments[1]
                type_instance.get_sdl_value(property).annotations << arguments[1][:annotation]
              end
            else
              new_item = property.type.new

              new_item.set_sdl_values(*arguments) unless arguments.empty?

              self.class.new(new_item).instance_exec(&block) if block
            end
          end

          new_item.parent = type_instance
          new_item.parent_index = existing_list.count

          existing_list << new_item
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
    instance.dup
  end

  def dynamic(&block)
    instance_eval &block
  end

  # Shortcuts for using 'yes' and 'no' in SDLs
  def yes
    true
  end

  def no
    false
  end
end