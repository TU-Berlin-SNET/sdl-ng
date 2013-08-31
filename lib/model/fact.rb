require_relative 'model_attributes'

class Fact
  include ModelAttributes

  attr :namespace
  attr :name

  def initialize(sym)
    @name = sym.to_s
  end

  def attributes
    attributes = {}

    self.model_attributes.each do |attribute|
      attributes[attribute.name] = send(attribute.name)
    end

    attributes
  end
end