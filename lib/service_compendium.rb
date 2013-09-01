require 'active_support/inflector'

require_relative 'receivers/receivers'

require_relative 'model/fact'
require_relative 'model/type'
require_relative 'model/model_attribute'

# A service compendium consists of service facts, types and services.
class ServiceCompendium
  attr :fact_classes
  attr :types
  attr :type_instances
  attr :services
  attr :current_namespace

  def initialize
    @fact_classes, @types = [], []
  end

  def facts_definition(&facts_definitions)
    self.instance_eval &facts_definitions
  end

  # Defines a new class of service facts
  def fact(sym, &fact_definition)
    receiver = FactReceiver.new(sym)
    receiver.instance_eval &fact_definition if block_given?
    @fact_classes.concat(receiver.classes)
  end

  def type(sym, &type_definition)
    receiver = TypeReceiver.new(sym)
    receiver.instance_eval &type_definition if block_given?
    @types << receiver.type_class
  end

  def namespace(uri)
    @current_namespace = uri
  end
end