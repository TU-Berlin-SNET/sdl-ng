module SDL
  module Base
    class Service
      attr_accessor :facts, :symbolic_name

      def initialize(symbolic_name)
        @symbolic_name = symbolic_name

        @facts, @facades = [], []
      end

      def fact_class_facts_map
        facts.group_by &:class
      end
    end
  end
end