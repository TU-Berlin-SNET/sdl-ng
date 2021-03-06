class SDL::Base::Type
  extend ActiveSupport::Autoload

  include SDL::Base::URIMappedResource

  autoload :Service

  class RecursiveSubtypes
    include Enumerable

    def initialize(type)
      @type = type
    end

    def each
      yield @type

      @type.subtypes.each do |subtype|
        subtype.subtypes_recursive.each do |type|
          yield type
        end
      end
    end
  end

  class RecursiveInstances
    include Enumerable

    def initialize(type)
      @type = type
    end

    def each
      @type.instances.each do |key, value|
        yield key, value
      end

      @type.subtypes.each do |subtype|
        subtype.instances_recursive.each do |key, value|
          yield key, value
        end
      end
    end
  end

  class << self
    include SDL::Base::URIMappedResource

    # The namespace URL of this Type class
    # !@attr [r] namespace
    attr_accessor :namespace

    # If the Type is a list item type
    # !@attr [r] list_item
    attr_accessor :list_item

    ##
    # The local name of the type, e.g. "Name" or "ServiceInterface". Defaults to the name of the class.
    #
    # The ServiceCompendium#register_classes_globally method makes this class accessible by a constant of this name
    @local_name

    alias :original_name :name

    def name
      original_name || local_name
    end

    def local_name
      @local_name || original_name.demodulize
    end

    def local_name=(name)
      @local_name = name
    end

    # A list of all subtypes
    # !@attr [r] subtypes
    # @return [<Class>] The subtypes
    def subtypes
      @subtypes ||= []
    end

    def [](symbol)
      instances[symbol]
    end

    def instances
      @instances ||= {}
    end

    def clear_instances!
      @instances = {}
    end

    def to_s
      @local_name || name
    end

    def properties(including_super = false)
      if including_super && is_sub?
        retrieved_properties = self.properties + superclass.properties(true)
      else
        retrieved_properties = @properties ||= []
      end

      retrieved_properties.each do |p|
        p.holder = self
      end
    end

    def clear_properties!
      @properties = []
    end

    def properties_hash(including_super = false)
      Hash[properties(including_super).collect do |p| [p.name.to_sym, p] end]
    end

    def propertyless?(including_super = true)
      properties(including_super).count == 0
    end

    def single_property?(including_super = true)
      properties(including_super).count == 1
    end

    def single_property(including_super = true)
      properties(including_super).first
    end

    def multi_property?(including_super = true)
      properties(including_super).count > 1
    end

    def list_item?
      @list_item == true
    end

    def is_sub?
      superclass != SDL::Base::Type
    end

    def subtypes_recursive
      RecursiveSubtypes.new(self)
    end

    def instances_recursive
      RecursiveInstances.new(self)
    end

    def find_subtype_recursive(symbol)
      subtypes_recursive.find do |subtype|
        subtype.local_name.underscore.eql? symbol.to_s
      end
    end

    # @return [Boolean] Has this Type already been registered with the compendium?
    def registered?
      @registered ||= false
    end

    def class_definition_string(sym, superklass)
      "class SDL::Base::Type::#{sym.to_s.camelize} < #{superklass.name}
        unless @registered
          include SDL::Types::SDLType

          wraps self
          codes local_name.underscore.to_sym

          superclass.subtypes << self

          @registered = true
        end
      end"
    end

    def unregister
      superclass.subtypes.delete self

      SDL::Base::Type.send(:remove_const, local_name.to_sym)
    end

    def define_type(sym, superklass = SDL::Base::Type)
      begin
        eval class_definition_string(sym, superklass)
      rescue SyntaxError => e
        raise e
      end

      SDL::Base::Type.const_get(sym.to_s.camelize)
    end

    def subtype(sym, &definition)
      type = define_type(sym, self)

      type.instance_eval(&definition) if block_given?

      return type
    end

    ##
    # Define a list of a type, which is defined in the block.
    def list(sym, &block)
      list_type = SDL::Base::Type.subtype(sym.to_s.singularize.to_sym, &block)

      # Designate as list type
      list_type.list_item = true

      add_property sym, list_type, true
    end

    def method_missing(name, *args, &block)
      if [:to_ary, :to_a].include?(name)
        raise NoMethodError
      end

      sym = args[0] || name.to_sym

      if name =~ /list_of_/
        multi = true
        type = SDL::Types::SDLType.codes[name.to_s.gsub('list_of_', '').singularize.to_sym]
        sym = sym.to_s.gsub('list_of_', '').to_sym
      else
        multi = false
        type = SDL::Types::SDLType.codes[name.to_sym]

        if !type
          type = SDL::Base::Type.subtype(sym)
          if block_given?
            type.instance_eval &block
          else
            raise "No block given for type definition of #{sym}"
          end
        end
      end

      add_property sym, type, multi
    end

    def respond_to_missing?(symbol, include_all = false)
      false
    end

    def add_property(sym, type, multi)
      properties.delete_if { |p| (p.name == sym.to_s) && puts("Warning: Overwritten property definition of #{p.to_s}").nil? }

      property = SDL::Base::Property.new(sym, type, self, multi)
      property.loaded_from = SDL::Base::ServiceCompendium.instance.current_uri
      
      (@properties ||= []) << property

      add_property_setters(sym, type, multi)
      add_property_getter(sym, type) unless multi
    end

    def add_property_setters(sym, type, multi)
      unless multi
        attr_reader sym

        # Setter
        define_method "#{sym}=" do |value|
          if type < SDL::Types::SDLSimpleType
            instance_variable_set "@#{sym}".to_s, type.new(value)
          else
            instance_variable_set "@#{sym}".to_s, value

            value.parent_object = self
          end
        end
      else
        # Define accessor method for lists
        define_method sym do
          eval "@#{sym} ||= []"
        end
      end
    end

    def add_property_getter(sym, type)
      define_method sym do
        instance_variable_get "@#{sym.to_s}"
      end
    end

    def sdl_ancestors
      ancestors.select{|a| a < SDL::Base::Type}
    end
  end

  def set_sdl_property(property, value)
    send "#{property.name}=", value
  end

  def get_sdl_value(property)
    send property.name
  end

  def set_sdl_values(*property_values)
    property_values.zip(self.class.properties(true)).each do |value, property|
      if(value.is_a?(Hash))
        # Setting values can be carried out by specifying the name of the property as a hash
        # e.g. a: 1, b: 2
        SDL::Receivers::TypeInstanceReceiver.new(self).send(value.first[0].to_s, value.first[1])
      else
        # Else, setting values is carried out by a value list, e.g. 1, 2
        unless property
          raise "Specified value '#{value}' for non-existing property."
        end

        SDL::Receivers::TypeInstanceReceiver.new(self).send(property.name, value)
      end
    end
  end

  ##
  # Gets the values of all properties
  def property_values(include_empty = false)
    pv = Hash[self.class.properties(true).map{|p| [p, send(p.name)]}]

    unless include_empty
      pv.reject! {|p, v| v.blank? }
    end

    pv
  end

  def to_s
    # If there is a property with the same name, than the type, return its to_s, return the name of the class
    naming_property = self.class.properties(true).find {|p| p.name.eql?(self.class.to_s.underscore) }

    if(naming_property)
      instance_variable_get("@#{naming_property.name.to_sym}").to_s
    else
      self.class.to_s
    end
  end

  def annotated?
    ! @annotations.blank?
  end

  def annotations
    @annotations ||= []
  end

  # Two type instances are the same if they either have the same identifier,
  # or are the same object
  def ==(other)
    if(identifier && other.respond_to?(:identifier))
      identifier == other.identifier
    else
      equal? other
    end
  end

  # An identifier for type instances
  attr_accessor :identifier

  # The index of this type instance in the parent list
  attr_accessor :parent_index

  # The parent of this type.
  attr_accessor :parent_object
end