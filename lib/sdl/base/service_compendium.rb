require 'active_support/inflector'

module SDL
  module Base
    ##
    # A service compendium allows the definition of service facts, types and services.
    class ServiceCompendium
      class << self
        def default_sdltypes
          @default_sdltypes ||= []
        end
      end

      attr :fact_classes
      attr :types
      attr :sdltype_codes
      attr :type_instances
      attr :services

      def initialize
        @fact_classes, @types, @type_instances, @services = [], [], [], []
        @sdltype_codes = {}

        register_default_types
      end

      def facts_definition(&facts_definitions)
        self.instance_eval &facts_definitions
      end

      # Defines a new class of service facts
      def fact(sym, &fact_definition)
        receiver = SDL::Receivers::FactReceiver.new(sym, self)
        receiver.instance_eval &fact_definition if block_given?
        @fact_classes.concat(receiver.fact_classes)
      end

      # Defines a new type to be used with properties
      def type(sym, &type_definition)
        receiver = SDL::Receivers::TypeReceiver.new(sym, self)
        receiver.instance_eval &type_definition if block_given?
        register_sdltype_codes(receiver.type_class)
        @types << receiver.type_class
      end

      # Defines a new service
      def service(sym, &service_definition)
        receiver = SDL::Receivers::ServiceReceiver.new(sym, self)
        receiver.instance_eval &service_definition if block_given?
        @services << receiver.service
      end

      ##
      # Registers the type under its codes
      def register_sdltype_codes(type)
        type.instance_variable_get(:@codes).each do |code|
          @sdltype_codes[code] = type
        end
      end

      ##
      # Registers all classes by their #local_name to be used in all scopes
      def register_classes_globally
        (@fact_classes + @types).each do |defined_class|
          Object.const_set defined_class.local_name, defined_class
        end
      end

      private
        ##
        # Registers all default types
        def register_default_types
          self.class.default_sdltypes.each do |type|
            register_sdltype_codes type
          end
        end
    end
  end
end