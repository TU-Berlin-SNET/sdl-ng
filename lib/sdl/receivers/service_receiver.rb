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
    end
  end
end