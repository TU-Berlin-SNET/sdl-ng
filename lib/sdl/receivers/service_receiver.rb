require_relative '../base/service'

module SDL
  module Receivers
    class ServiceReceiver
      include ActiveSupport::Inflector

      attr :service

      def initialize(sym, compendium)
        @service = SDL::Base::Service.new(sym.to_s)

        compendium.fact_classes.each do |fact_class|
          define_singleton_method("has_#{fact_class.local_name.underscore}") do |value = nil, &block|
            add_fact fact_class, value, &block
          end

          define_singleton_method("#{fact_class.local_name.underscore}") do |value = nil, &block|
            add_fact fact_class, value, &block
          end
        end
      end

      private
        def add_fact(fact_class, value, &block)
          fact_instance = fact_class.new

          set_value(fact_class, fact_instance, value) if value

          if block_given?
            fact_instance.receiver.instance_eval &block
          end

          @service.facts << fact_instance
        end

      # If a value is given, search for all SDL::Base::Fact ancestor classes until a
      # property is found, which has the same name as its class. Set it using the receiver.
      def set_value(fact_class, fact_instance, value)
        fact_class.ancestors.each do |ancestor_class|
          break if ancestor_class.eql? SDL::Base::Fact

          ancestor_class.properties.each do |property|
            if property.name.eql? ancestor_class.local_name.underscore
              fact_instance.receiver.send("#{ancestor_class.local_name.underscore}", value)

              return
            end
          end
        end

        raise "I didn't know what property of class #{fact_class.local_name} to set to value #{value}."
      end
    end
  end
end