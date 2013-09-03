require_relative 'attribute_definitions'

class FactReceiver
  include ActiveSupport::Inflector
  include AttributeDefinitions

  attr :fact_class
  attr :fact_classes

  define_attributes_for :fact_class

  def initialize(sym)
    @fact_class = Class.new(Fact)
    @fact_class.local_name = sym.to_s.camelize

    @fact_classes = [@fact_class]
  end

  def better(sym)

  end

  def subfact(sym, &fact_type_definition)
    receiver = FactReceiver.new(sym)
    receiver.instance_eval(&fact_type_definition) if block_given?

    fact_classes.concat(receiver.fact_classes)
  end
end