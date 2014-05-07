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
  # An enumerator of all registered +Type+ classes
  # @!attribute [r] types
  # @return [Enumerable<Class>]
  def types
    SDL::Base::Type.subtypes_recursive.drop(2)
  end

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
  # A map containing predefined type instances, mapped to their Type classes.
  #
  # @!attribute [r] type_instances
  # @return Hash{Class => Hash{Symbol => Type}}
  def type_instances
    type_instances = {}

    types.each do |type|
      type_instances[type] = type.instances
    end

    type_instances
  end

  ##
  # A map of service names to service objects. It contains all loaded services in
  # this compendium.
  #
  # @!attribute [r] services
  # @return Hash{String => Service}
  def services
    SDL::Base::Type::Service.instances
  end

  ##
  # The current URI when loading services.
  #
  # @!attribute [r] current_uri
  # @return [String]
  attr :current_uri

  ##
  # Initializes the compendium.
  def initialize
    @services = {}
    @type_instances, @sdl_simple_type_codes, @type_codes, @all_codes = {}, {}, {}, {}

    @type_instances.default = {}

    register_default_types

    @current_uri = :default

    type :service
  end

  ##
  # A compendium is empty, if there are neither types, nor services loaded.
  # @return [Boolean] If this compendium is empty.
  def empty?
    SDL::Base::Type.subtypes_recursive.count == 2 &&
    SDL::Base::Type.instances_recursive.to_a.empty?
  end

  # Clears all loaded types and instances
  def clear!
    SDL::Base::Type::Service.clear_instances!

    SDL::Base::Type.subtypes_recursive.drop(2).each do |type|
      type.codes.each do |code|
        @all_codes.delete code
        @type_codes.delete code
      end

      type.unregister
    end

    SDL::Base::Type::Service.clear_properties!
  end

  def facts_definition(&facts_definitions)
    type :service, &facts_definitions
  end

  alias_method :service_properties, :facts_definition

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

  # Defines a new type and returns it
  def type(sym, &type_definition)
    type = SDL::Base::Type.subtype(sym, &type_definition)

    SDL::Base::Type.subtypes_recursive.drop(1).each do |type|
      # All newly loaded types have loaded_from.nil?
      # Cannot iterate over subtypes, as types can define property types on the fly, which are
      # certainly NOT subtypes of themselves
      if(type.loaded_from.nil?)
        type.loaded_from = @current_uri
        register_codes type
        register_sdltype type
      end
    end

    type
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
      create_type_instance(type, identifier, &block)
    end
  end

  # @param [Class] type The instance type
  # @param [Symbol] identifier The identifier
  def create_type_instance(type, identifier, &block)
    receiver = SDL::Receivers::TypeInstanceReceiver.new(type.new)

    receiver.instance_eval &block if block != nil

    receiver.instance.loaded_from = current_uri
    receiver.instance.identifier = identifier

    type.instances[identifier] = receiver.instance
  end

  ##
  # Registers all classes by their #local_name to be used in all scopes
  def register_classes_globally
    SDL::Base::Type.subtypes_recursive.each do |defined_class|
      Object.send(:remove_const, defined_class.local_name) if Object.const_defined? defined_class.local_name.to_sym
      Object.const_set defined_class.local_name, defined_class
    end
  end

  ##
  # Yields all items, which were loaded by this compendium
  def loaded_items
    SDL::Base::Type.subtypes_recursive.drop(1).each do |type|
      yield type

      type.instances.each do |sym, instance|
        yield instance
      end
    end
  end

  ##
  # Unloads all items with the specified uri from this service compendium
  def unload(uri)
    SDL::Base::Type::Service.instances.delete_if do |symbolic_name, service|
      service.loaded_from.eql?(uri)
    end

    SDL::Base::Type.subtypes_recursive.each do |type|
      if type.loaded_from.eql?(uri) then
        type.codes.each do |code|
          @all_codes.delete code
          @type_codes.delete code
        end

        type.unregister
      end
    end
  end

  # This module contains the #loaded_from attribute for all items, which can be loaded by a service compendium
  module ServiceCompendiumMixin
    attr_accessor :loaded_from

    [SDL::Base::Type, SDL::Base::Type.class].each do |klass|
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