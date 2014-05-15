##
# Base SDL type.
#
# All types share a common constructor, which delegates part of its functionality.
class SDL::Types::SDLSimpleType
  include SDL::Types::SDLType

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
  # @param[Object] raw_value
  #   The instance value. Unless the value class is a subclass of the wrapped Ruby class,
  #   perform conversion by invoking +from_#{classname}+, e.g. +from_string+ or +from_integer+.
  #
  #   Subclasses are expected to implement this conversion function.
  def initialize(raw_value)
    @raw_value = raw_value

    initialize_value
  end

  def initialize_value
    if raw_value.class <= self.class.wrapped_type
      @value = raw_value
    else
      begin
        send(conversion_method_name(raw_value), raw_value)
      rescue NoMethodError
        raise "Cannot create instance of #{self.class.name} with a #{raw_value.class.name} value. Please implement #{self.class.name}##{conversion_method_name(raw_value)}"
      end
    end
  end

  def ==(value)
    @value == value
  end

  def to_s
    @value.to_s
  end

  def annotated?
    ! @annotations.blank?
  end

  def annotations
    @annotations ||= []
  end

  # The index of this type instance in the parent list
  attr_accessor :parent_index

  # The parent of this type.
  attr_accessor :parent

  private
    def conversion_method_name(value)
      'from_' + value.class.name.underscore.gsub('/', '_')
    end
end