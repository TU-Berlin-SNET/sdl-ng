require 'verbs'

require_relative '../base/service'

module SDL
  module Receivers
    class ServiceReceiver
      include ActiveSupport::Inflector

      attr :service
      attr :compendium

      def initialize(sym, compendium)
        @service = SDL::Base::Service.new(sym.to_s)
        @compendium = compendium

        compendium.fact_classes.each do |fact_class|
          define_singleton_method("is_#{fact_class.local_name.underscore.verb.conjugate(:tense => :past, :person => :third, :plurality => :singular, :aspect => :perfective)}") do |*args, &block|
            add_fact fact_class, *args, &block
          end

          define_singleton_method("has_#{fact_class.local_name.underscore}") do |*args, &block|
            add_fact fact_class, *args, &block
          end

          define_singleton_method("#{fact_class.local_name.underscore}") do |*args, &block|
            add_fact fact_class, *args, &block
          end
        end
      end

      private
        def add_fact(fact_class, *property_values, &block)
          fact_instance = fact_class.new
          fact_instance.service = @service

          SDL::Receivers.set_value(fact_class, fact_instance, *property_values, @compendium)

          if block_given?
            SDL::Receivers::TypeInstanceReceiver.new(fact_instance, @compendium).instance_eval &block
          end

          @service.facts << fact_instance
        end

        ##
        # Catches calls to methods named similarily to possible predefined type instances
        def method_missing(name, *args)
          possible_type_instances = @compendium.type_instances.map{|k, v| v[name]}.select{|v| v != nil}

          unless possible_type_instances.nil? || possible_type_instances.empty?
            if possible_type_instances.length > 1
              raise Exception.new("Multiple possibilities for #{name} in #{caller[0]}")
            else
              possible_type_instances[0]
            end
          else
            raise Exception.new("I do not know what to do with '#{name}' in #{caller[0]}")
          end
        end
    end
  end
end