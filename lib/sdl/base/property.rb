##
# A property of a Fact or Type. It has a #name and an associated Type.
class SDL::Base::Property
  ##
  # The Property name
  # @!attribute [r] name
  # @return [String]
  attr :name

  ##
  # The Property Type
  # @!attribute [r] type
  # @return [Class]
  attr :type

  ##
  # Is this Property multi-valued
  # @!attribute [r] multi
  # @return [Boolean]
  attr :multi

  ##
  # The type, for which the property is defined
  # @!attribute [r] parent
  # @return [Class]
  attr :parent

  ##
  # The type, which currently holds this property
  # @!attribute [r] holder
  # @return [Class]
  attr_accessor :holder

  ##
  # Is this Property single-valued
  # @return [Boolean]
  def single?
    !@multi
  end

  ##
  # Is this Property multi-valued
  # @return [Boolean]
  def multi?
    @multi
  end

  ##
  # Was this property inherited from one of its parents?
  # @return [Boolean]
  def inherited?
    ! parent.eql? holder
  end

  # Define a property by its name and type
  def initialize(name, type, parent, multi = false)
    @name, @type, @parent, @multi = name.to_s, type, parent, multi
  end
end