require 'active_support/inflector'

require_relative 'model/fact'
require_relative 'model/type'
require_relative 'model/model_attribute'

# A service compendium consists of service facts, types and services.
class ServiceCompendium
  attr :fact_classes
  attr :types

  def initialize
    @fact_classes, @types = [], []
  end

  def facts_definition(&facts_definitions)
    FactsDefinitionReceiver.new(self).instance_eval &facts_definitions
  end
end

# Receives definitions for facts and types and adds these to a compendium
class FactsDefinitionReceiver
  attr :compendium
  attr :namespace

  def initialize(compendium)
    @compendium = compendium
  end

  def namespace(uri)
    @namespace = uri
  end

  # Defines a new class of service facts
  def fact(sym, &fact_definition)
    receiver = FactDefinitionReceiver.new(sym)
    receiver.instance_eval &fact_definition if block_given?
    [receiver.fact_class, receiver.subclasses].flatten.each do |c| @compendium.fact_classes << c end
  end

  def type(sym, &type_definition)
    receiver = TypeDefinitionReceiver.new(sym)
    receiver.instance_eval &type_definition if block_given?
    @compendium.types << receiver.type_class
  end
end

class FactDefinitionReceiver
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

    receiver = ModelAttributeDefinitionReceiver.new(model_attribute)
    receiver.instance_eval &attribute_definition if block_given?

    fact_class.class_eval do
      model_attributes << model_attribute
    end
  end

  def subfact(sym, &fact_type_definition)
    receiver = FactDefinitionReceiver.new(sym)
    receiver.instance_eval(&fact_type_definition) if block_given?

    [receiver.fact_class, receiver.subclasses].flatten.each do |c| subclasses << c end
  end

  def method_missing(name, *args, &block)
    if name =~ /list_of_/ then
      list block
    end
  end
end

class ModelAttributeDefinitionReceiver
  include ActiveSupport::Inflector

  attr :model_attribute

  def initialize(model_attribute)
    @model_attribute = model_attribute
  end

  def type(sym)
    @model_attribute.type = sym.to_s.camelize.constantize
  end
end

class TypeDefinitionReceiver
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