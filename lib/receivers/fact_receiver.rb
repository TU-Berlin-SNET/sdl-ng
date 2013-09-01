class FactReceiver
  include ActiveSupport::Inflector

  attr_reader :fact_class
  attr_reader :subclasses

  def initialize(sym)
    @fact_class = Class.new(Fact)

    Object.const_set(sym.to_s.camelize, @fact_class)

    @subclasses = []
  end

  def better(sym)

  end

  def list(sym, &attribute_definition)
    model_attribute = ModelAttribute.new(sym, Array)

    receiver = ModelAttributeReceiver.new(model_attribute)
    receiver.instance_eval &attribute_definition if block_given?

    fact_class.class_eval do
      model_attributes << model_attribute
    end
  end

  def subfact(sym, &fact_type_definition)
    receiver = FactReceiver.new(sym)
    receiver.instance_eval(&fact_type_definition) if block_given?

    subclasses.concat(receiver.classes)
  end

  def classes
    [@fact_class, @subclasses].flatten
  end

  def method_missing(name, *args, &block)
    if name =~ /list_of_/ then
      list(args[0], &block)
    end
  end
end