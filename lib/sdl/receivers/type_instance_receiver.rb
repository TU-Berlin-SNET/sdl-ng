##
# Receiver for setting the properties of Type instances
class SDL::Receivers::TypeInstanceReceiver
  class InstanceReference
    attr :identifier

    attr :possible_instances

    def initialize(sym)
      @identifier = sym

      @possible_instances = SDL::Base::Type.instances_recursive.each_with_object([]) do |kv, list|
        list.push(kv[1]) if kv[0] == sym
      end
    end

    def resolveable?
      @possible_instances.count > 0
    end

    # Returns all possible instances for this property
    def resolve(property)
      @possible_instances.find_all do |instance|
        instance.class <= property.type
      end
    end

    # Returns the matching instance for this property or raises an error if zero or more than one instances are found
    def resolve!(property)
      matching_instances = resolve(property)

      case matching_instances.count
        when 1
          return matching_instances.first
        when 0
          raise "Cannot find an instance named #{@identifier}, which would match the type of #{property}."
        else
          raise "Ambiguous reference to #{@identifier} for property #{property}."
      end
    end
  end

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
        define_singleton_method property.name do |*arguments, &block|
          if property.simple_type?
            type_instance.set_sdl_property property, arguments[0]

            if arguments[1]
              type_instance.get_sdl_value(property).annotations << arguments[1][:annotation]
            end
          else
            begin
              # There are two possibilities here:
              if(arguments.first.is_a?(InstanceReference) && arguments.first.resolve(property).count == 1)
                # 1. The user provides a predefined instance for this property
                resolved_instance_copy = refer_or_copy(arguments.first.resolve!(property))

                arguments.each do |arg|
                  if arg.is_a?(Hash) && arg[:annotation]
                    new_item.annotations << arg[:annotation]
                  end
                end

                type_instance.set_sdl_property property, resolved_instance_copy
              else
                # The arguments are values for a new instance
                property_type_instance = property.type.new

                property_type_instance.set_sdl_values(*arguments)

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

          if property.simple_type?
            # Add to a list of simple types by using the first argument as the raw_value of a new item
            new_item = property.type.new
            new_item.raw_value = arguments[0]

            if arguments[1]
              type_instance.get_sdl_value(property).annotations << arguments[1][:annotation]
            end
          else
            # There are two possibilities here:
            if(arguments.first.is_a?(InstanceReference) && arguments.first.resolve(property).count == 1)
              # 1. The user provides a predefined instance for this property
              new_item = refer_or_copy(arguments.first.resolve!(property))

              arguments.each do |arg|
                if arg.is_a?(Hash) && arg[:annotation]
                  new_item.annotations << arg[:annotation]
                end
              end
            else
              # 2. The user provides property values for a new instance of the type class of this property
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
  # Catches calls to methods named similarily to possible predefined type instances by returning a InstanceReference
  # instance or raising an exception.
  def method_missing(name, *args)
    reference = InstanceReference.new(name.to_sym)

    if reference.resolveable?
      return reference
    else
      raise Exception.new("There is no predefined instance named '#{name}'.")
    end
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