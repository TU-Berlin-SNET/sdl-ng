##
# A property of a Fact or Type. It has a #name and an associated Type.
class SDL::Base::Property
  # The Property name
  attr :name

  # The Property Type
  attr :type

  # Is this Property multi-valued
  attr :multi

  # The parent type, where this property belongs to
  attr :parent

  # Is this Property single-valued
  def single?
    !@multi
  end

  # Is this Property multi-valued
  def multi?
    @multi
  end

  # Define a property by its name and type
  def initialize(name, type, parent, multi = false)
    @name, @type, @parent, @multi = name.to_s, type, parent, multi
  end
end