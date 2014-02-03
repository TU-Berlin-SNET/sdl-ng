class SDL::Base::Type
  include SDL::Base::URIMappedResource

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
      not [SDL::Base::Type, SDL::Base::Fact].include? superclass
    end

    def sdl_ancestors
      ancestors.drop(1).take_while {|ancestor| ! [SDL::Base::Type, SDL::Base::Fact, SDL::Types::SDLType].include? ancestor}
    end
  end

  ##
  # Gets the values of all properties
  def property_values(include_empty = true)
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

  # An identifier for type instances
  attr_accessor :identifier

  # The index of this type instance in the parent list
  attr_accessor :parent_index

  # The parent of this type.
  attr_accessor :parent
end