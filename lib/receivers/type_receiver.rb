require_relative 'attribute_definitions'

class TypeReceiver
  include ActiveSupport::Inflector
  include AttributeDefinitions

  define_attributes_for :type_class

  attr :type_class

  def initialize(sym)
    @type_class = Class.new(Type)
    @type_class.local_name = sym.to_s.camelize
  end
end