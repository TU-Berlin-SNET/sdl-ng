##
# Base SDL type.
#
# All types share a common constructor, which delegates part of its functionality.
class SDL::Types::SDLSimpleType
  include SDL::Types::SDLType

  ##
  # Array of all SDLSimpleTypes. Used by the ServiceCompendium.
  def self.sdl_types
    @@sdl_types ||= []
  end

  ##
  # Every descendant of SDLSimpleType registers it with this class, so that all ServiceCompendiums
  # recognize the codes of descendants.
  def self.inherited(subclass)
    sdl_types << subclass
  end

  # The SDL value type value, possibly converted to the wrapped ruby type, e.g., an URI object created from an
  # "http://" String
  attr_reader :value

  # The raw value, with which this type was instatiated
  attr_reader :raw_value

  ##
  # Creates a new instance of an SDL type.
  #
  # Invokes +from_+ methods of subtypes, if +value+ is not subtype of the wrapped Ruby type.
  #
  # @param[Object] value
  #   The instance value. Unless the value class is a subclass of the wrapped Ruby class,
  #   perform conversion by invoking +from_#{classname}+, e.g. +from_string+ or +from_integer+.
  #
  #   Subclasses are expected to implement this conversion function.
  def initialize(value)
    @raw_value = value

    if value.class <= self.class.wrapped_type
      @value = value
    else
      begin
        send(conversion_method_name(value), value)
      rescue NoMethodError
        raise "Cannot create instance of #{self.class.name} with a #{value.class.name} value. Please implement #{self.class.name}##{conversion_method_name(value)}"
      end
    end
  end

  def ==(value)
    @value == value
  end

  def to_s
    @value.to_s
  end

  private
    def conversion_method_name(value)
      value.class.name.demodulize.camelize.downcase
    end
end