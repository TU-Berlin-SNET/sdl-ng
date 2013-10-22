module SDL
  module Base
    class Service
      attr_accessor :facts, :symbolic_name

      def initialize(symbolic_name)
        @symbolic_name = symbolic_name

        @facts, @facades = [], []
      end
    end
  end
end