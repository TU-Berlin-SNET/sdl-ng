##
# A service compendium allows the definition of service facts, types and services.
class SDL::Base::ServiceCompendium
  extend ActiveSupport::Autoload

  autoload :LoadTransaction
  autoload :VocabularyLoadTransaction
  autoload :ServiceLoadTransaction

  include VocabularyLoadTransaction
  include ServiceLoadTransaction

  ##
  # A list of all +Fact+ classes registered in this compendium
  # @!attribute [r] fact_classes
  # @return [Array<Class>]
  attr :fact_classes

  ##
  # A list of all +Type+ classes registered in this compendium
  # @!attribute [r] types
  # @return [Array<Class>]
  attr :types

  ##
  # Registered codes for +SDLSimpleType+s and +Type+s.
  #
  # These are used in the definition of the type of a property.
  #
  # @!attribute [r] all_codes
  # @return [Hash{String => Class}]
  attr :all_codes

  ##
  # Registered codes for +SDLSimpleType+s.
  #
  # These are used in the definition of the type of a property.
  #
  # @!attribute [r] sdl_simple_type_codes
  # @return [Hash{String => Class}]
  attr :sdl_simple_type_codes

  ##
  # Registered codes for +Type+s.
  #
  # These are used in the definition of the type of a property.
  #
  # @!attribute [r] type_codes
  # @return [Hash{String => Class}]
  attr :type_codes

  ##
  # Registered codes for +SDL

  ##
  # A map containing predefined type instances, mapped to their Type classes.
  #
  # @!attribute [r] type_instances
  # @return Hash{Class => Hash{Symbol => Type}}
  attr :type_instances

  ##
  # A map of service names to service objects. It contains all loaded services in
  # this compendium.
  #
  # @!attribute [r] services
  # @return Hash{String => Service}
  attr :services

  ##
  # The service compendium specific copy of the ServiceMethods module. See #ServiceMethods
  #
  # @!attribute [r] service_methods
  # @return [Module]
  attr :service_methods

  ##
  # The current URI when loading services.
  #
  # @!attribute [r] current_uri
  # @return [String]
  attr :current_uri

  ##
  # Initializes the compendium.
  def initialize
    @fact_classes, @types, @services = [], [], {}
    @type_instances, @sdl_simple_type_codes, @type_codes, @all_codes = {}, {}, {}, {}

    @type_instances.default = {}

    @service_methods = Module.new() do |mod|
      include ServiceMethods
    end

    register_default_types
  end

  ##
  # A compendium is empty, if there are neither types, nor services loaded.
  # @return [Boolean] If this compendium is empty.
  def empty?
    @fact_classes.empty? &&
        @types.empty? &&
        @services.empty? &&
        @type_instances.empty? &&
        @type_codes.empty?
  end

  def facts_definition(&facts_definitions)
    self.instance_eval &facts_definitions
  end

  def type_instances_definition(&type_instances_definition)
    self.instance_eval &type_instances_definition
  end

  ##
  # Runs the +&block+ with specified +current_uri+ and restores the old +current_uri+.
  #
  # @param [String] current_uri The URI, with which the block should be run.
  # @param [Block] block The block, which will be called.
  def with_uri(current_uri, &block)
    old_uri = @current_uri
    @current_uri = current_uri

    begin
      block.call
    ensure
      @current_uri = old_uri
    end
  end

  # Defines a new class of service facts
  def fact(sym, &fact_definition)
    receiver = SDL::Receivers::FactReceiver.new(sym, self)
    receiver.instance_eval &fact_definition if block_given?
    receiver.subclasses.each do |fact_class|
      fact_class.loaded_from = @current_uri

      @fact_classes << fact_class

      # Refer to the symbolic name of the current class, which can be a subclass of
      sym = fact_class.local_name.underscore.to_sym

      # Extend the @service_methods module with methods retrieving the first or all
      # instances of this fact, e.g. "service.features" would find all Feature facts
      @service_methods.class_eval do
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
    receiver.klass.loaded_from = @current_uri
    receiver.instance_eval &type_definition if block_given?

    @types.concat receiver.subclasses

    receiver.subclasses.each do |klass|
      klass.loaded_from = @current_uri
      register_codes klass
      register_sdltype klass
      @type_instances[klass] = {}
    end

    receiver.klass
  end

  # Defines a new service, adds all service methods, and returns it
  def service(sym, &service_definition)
    receiver = SDL::Receivers::ServiceReceiver.new(sym, self)
    receiver.instance_eval &service_definition if block_given?
    receiver.service.loaded_from = current_uri
    @services[sym] = receiver.service
    receiver.service.symbolic_name = sym.to_s
    receiver.service.compendium = self
    receiver.service.extend @service_methods
    receiver.service
  end

  ##
  # Registers an SDLSimpleType or SDLType under its code
  # @param [Class] type The type to be registered.
  def register_codes(type)
    if type < SDL::Types::SDLSimpleType
      type.codes.each do |c| @sdl_simple_type_codes[c] = type end
    else
      type.codes.each do |c| @type_codes[c] = type end
    end

    type.codes.each do |code|
      @all_codes[code] = type
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

      receiver.instance.loaded_from = current_uri
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

  ##
  # Returns an iterator for all items, which were loaded by this compendium
  def loaded_items
    @fact_classes.each do |fact_class|
      yield fact_class
    end

    @types.each do |type_class|
      yield type_class
    end

    @type_instances.each do |type_class, instance_hash|
      instance_hash.each do |symbol, instance|
        yield instance
      end
    end

    @services.each do |symbol, service|
      yield service
    end
  end

  ##
  # Unloads all items with the specified uri from this service compendium
  def unload(uri)
    @services.delete_if do |symbolic_name, service| service.loaded_from.eql?(uri) end

    @fact_classes.delete_if do |item| item.loaded_from.eql?(uri) end

    @types.delete_if do |item|
      if item.loaded_from.eql?(uri) then
        @type_instances.delete(item)

        @all_codes.delete_if do |code, type| type.eql? item end
        @type_codes.delete_if do |code, type| type.eql? item end

        true
      else
        false
      end
    end
  end

  # This module is included in every service defined by this compendium and contains methods to easily retreive
  # certain fact instances by their name.
  module ServiceMethods

  end

  # This module contains the #loaded_from attribute for all items, which can be loaded by a service compendium
  module ServiceCompendiumMixin
    attr_accessor :loaded_from

    [SDL::Base::Type, SDL::Base::Type.class, SDL::Base::Service].each do |klass|
      klass.instance_eval do
        include SDL::Base::ServiceCompendium::ServiceCompendiumMixin
      end
    end
  end

  private
    ##
    # Registers all default types
    def register_default_types
      SDL::Types::SDLSimpleType.descendants.each do |type|
        register_codes type
      end
    end
end