require_relative 'model_attributes'

class Type
  include ModelAttributes

  attr :name

  def initialize(sym)
    @name = sym.to_s
  end
end