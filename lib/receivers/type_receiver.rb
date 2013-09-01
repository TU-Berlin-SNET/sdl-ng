class TypeReceiver
  include ActiveSupport::Inflector

  attr :type_class

  def initialize(sym)
    @type_class = Class.new(Type)

    Object.const_set(sym.to_s.camelize, @type_class)
  end

  def string(sym)
    @type_class.model_attributes << ModelAttribute.new(sym, String)
  end
end