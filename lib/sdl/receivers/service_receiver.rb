require 'verbs'

class SDL::Receivers::ServiceReceiver < SDL::Receivers::Receiver
  include ActiveSupport::Inflector

  attr :service

  def initialize(sym, compendium)
    super(compendium)

    @service = SDL::Base::Service.new(sym.to_s)

    compendium.fact_classes.each do |fact_class|
      fact_class.keywords.each do |keyword|
        define_singleton_method keyword do |*args, &block|
          add_fact fact_class, *args, &block
        end
      end
    end
  end

  private
    def add_fact(fact_class, *property_values, &block)
      fact_instance = fact_class.new
      fact_instance.service = @service

      set_value(fact_class, fact_instance, *property_values)

      if block_given?
        SDL::Receivers::TypeInstanceReceiver.new(fact_instance, @compendium).instance_eval &block
      end

      @service.facts << fact_instance

      fact_instance.parent_index = @service.fact_class_facts_map[fact_class].count - 1
    end

    ##
    # Catches calls to methods named similarily to possible predefined type instances
    def method_missing(name, *args)
      possible_type_instances = @compendium.type_instances.map{|k, v| v[name]}.select{|v| v != nil}

      unless possible_type_instances.nil? || possible_type_instances.empty?
        if possible_type_instances.length > 1
          raise Exception.new("Multiple possibilities for #{name}")
        else
          possible_type_instances[0]
        end
      else
        raise Exception.new("I do not know what to do with '#{name}'")
      end
    end
end