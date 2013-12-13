module SDL
  module Exporters
    class Exporter
      attr :compendium
      attr :options

      def initialize(compendium, options = {})
        @compendium = compendium
        @options = options
      end

      def export_to_file(path, content)
        File.open(path, 'w') do |f|
          f.write(content)
        end
      end
    end
  end
end