##
# A service compendium allows the definition of service facts, types and services.
class SDL::Base::ServiceCompendium
  attr :fact_classes
  attr :types
  attr :sdltype_codes
  attr :type_instances
  attr :services

  def initialize
    @fact_classes, @types, @services = [], [], {}
    @type_instances, @sdltype_codes = {}, {}

    register_default_types
  end

  def facts_definition(&facts_definitions)
    self.instance_eval &facts_definitions
  end

  def type_instances_definition(&type_instances_definition)
    self.instance_eval &type_instances_definition
  end

  # Defines a new class of service facts
  def fact(sym, &fact_definition)
    receiver = SDL::Receivers::FactReceiver.new(sym, self)
    receiver.instance_eval &fact_definition if block_given?
    receiver.subclasses.each do |fact_class|
      @fact_classes << fact_class

      # Refer to the symbolic name of the current class, which can be a subclass of
      sym = fact_class.local_name.underscore.to_sym

      ServiceMethods.class_eval do
        unless SDL::Base::Service.instance_methods.include? sym
          define_method sym do
            @facts.find {|fact| fact.is_a? fact_class}
          end
        end

        unless SDL::Base::Service.instance_methods.include? sym.to_s.pluralize.to_sym
          define_method sym.to_s.pluralize do
            @facts.find_all {|fact| fact.is_a? fact_class}
          end
        end
      end
    end
  end

  # Defines a new type and returns it
  def type(sym, &type_definition)
    receiver = SDL::Receivers::TypeReceiver.new(sym, self)
    receiver.instance_eval &type_definition if block_given?
    register_sdltype_codes(receiver.klass)
    register_sdltype(receiver.klass)
    @types << receiver.klass
    @type_instances[receiver.klass] = {}
    receiver.klass
  end

  # Defines a new service, adds all service methods, and returns it
  def service(sym, &service_definition)
    receiver = SDL::Receivers::ServiceReceiver.new(sym, self)
    receiver.instance_eval &service_definition if block_given?
    @services[sym] = receiver.service
    receiver.service.symbolic_name = sym.to_s
    receiver.service.extend ServiceMethods
    receiver.service
  end

  ##
  # Registers the type under its codes
  def register_sdltype_codes(type)
    type.instance_variable_get(:@codes).each do |code|
      @sdltype_codes[code] = type
    end
  end

  ##
  # Allows this compendium to be used for adding new type instances
  def register_sdltype(type)
    # Define a method, which adds the type instance defined in the block to this compendium and adds it as a
    # constant the the type class
    self.class.send(:define_method, type.local_name.underscore) do |identifier, &block|
      receiver = SDL::Receivers::TypeInstanceReceiver.new(type.new, self)

      receiver.instance_eval &block if block != nil

      receiver.instance.identifier = identifier
      @type_instances[type][identifier] = receiver.instance
    end
  end

  ##
  # Registers all classes by their #local_name to be used in all scopes
  def register_classes_globally
    (@fact_classes + @types).each do |defined_class|
      Object.send(:remove_const, defined_class.local_name) if Object.const_defined? defined_class.local_name.to_sym
      Object.const_set defined_class.local_name, defined_class
    end
  end

  # This module is included in every service defined by this compendium and contains methods to easily retreive
  # certain fact instances by their name.
  module ServiceMethods

  end

  private
    ##
    # Registers all default types
    def register_default_types
      SDL::Types::SDLSimpleType.descendants.each do |type|
        register_sdltype_codes type
      end
    end
end