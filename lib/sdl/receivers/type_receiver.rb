class SDL::Receivers::TypeReceiver < SDL::Receivers::Receiver
  include ActiveSupport::Inflector

  # The class for which the type receiver was instantiated
  # !@attr [r] klass
  # @return [Class]
  attr :klass

  # The class and all subclasses
  # !@attr [r] subclasses
  # @return [Array<Class>]
  attr :subclasses

  def initialize(sym, compendium, superklass = nil)
    super(compendium)

    @klass = Class.new(superklass || base_class)
    @klass.local_name = sym.to_s.camelize

    @subclasses = [@klass]

    register_sdltype(@klass)
  end

  def base_class
    SDL::Base::Type
  end

  def register_sdltype(klass)
    klass.class_eval do
      include SDL::Types::SDLType

      wraps self
      codes local_name.underscore.to_sym
    end
  end

  def subtype(sym, &definition)
    receiver = self.class.new(sym, @compendium, @klass)
    receiver.instance_eval(&definition) if block_given?
    klass.subtypes << receiver.klass

    @subclasses.concat(receiver.subclasses)
  end

  ##
  # Define a list of a type, which is defined in the block.
  def list(name, &block)
    list_type = @compendium.type name.to_s.singularize.to_sym, &block

    # Designate as list type
    list_type.list_item = true

    add_property name.to_sym, list_type, true
  end

  def method_missing(name, *args, &block)
    sym = args[0] || name.to_sym

    if name =~ /list_of_/
      multi = true
      type = @compendium.all_codes[name.to_s.gsub('list_of_', '').singularize.to_sym]
    else
      multi = false
      type = @compendium.all_codes[name.to_sym]
    end

    if type
      add_property sym, type, multi
    else
      super(name, *args, &block)
    end
  end

  private
    ##
    # Adds accessors to set the property to the target class.
    #
    # These accessors set the instance variable to the given value and set the parent of the value to self.
    def add_property(sym, type, multi)
      unless multi
        @klass.class_eval do
          attr_reader sym

          # Setter
          define_method "#{sym}=" do |value|
            if type < SDL::Types::SDLSimpleType
              instance_variable_set "@#{sym}".to_s, type.new(value)
            else
              instance_variable_set "@#{sym}".to_s, value

              value.parent = self
            end
          end
        end
      else
        # Define accessor method for lists
        @klass.class_eval do
          define_method sym do
            eval "@#{sym} ||= []"
          end
        end
      end

      @klass.properties << SDL::Base::Property.new(sym, type, @klass, multi)
    end
end