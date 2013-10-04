module SDL
  module Exporters
    class Exporter
      attr :compendium
      attr :options

      def initialize(compendium, options = {})
        @compendium = compendium
        @options = options
      end
    end
  end
end