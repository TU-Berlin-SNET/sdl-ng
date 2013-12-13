module SDL
  module Exporters
    class SchemaExporter < Exporter
      def export_schema_to_file(path)
        export_to_file path, export_schema
      end
    end
  end
end