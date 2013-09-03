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
    @fact_classes, @types, @services = [], [], []
  end

  def facts_definition(&facts_definitions)
    self.instance_eval &facts_definitions
  end

  # Defines a new class of service facts
  def fact(sym, &fact_definition)
    receiver = FactReceiver.new(sym)
    receiver.instance_eval &fact_definition if block_given?
    @fact_classes.concat(receiver.fact_classes)
  end

  # Defines a new type to be used with facts
  def type(sym, &type_definition)
    receiver = TypeReceiver.new(sym)
    receiver.instance_eval &type_definition if block_given?
    @types << receiver.type_class
  end

  # Defines a new service
  def service(sym, &service_definition)
    receiver = ServiceReceiver.new(sym, self)
    receiver.instance_eval &service_definition if block_given?
    @services << receiver.service
  end

  def namespace(uri)
    @current_namespace = uri
  end

  def register_classes_globally
    @fact_classes.each do |fact_class|
      Object.const_set(fact_class.local_name, fact_class)
    end
  end
end