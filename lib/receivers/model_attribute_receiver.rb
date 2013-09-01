class ModelAttributeReceiver
  include ActiveSupport::Inflector

  attr :model_attribute

  def initialize(model_attribute)
    @model_attribute = model_attribute
  end

  def type(sym)
    @model_attribute.type = sym.to_s.camelize.constantize
  end

  def better(sym)

  end
end