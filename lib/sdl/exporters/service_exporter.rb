module SDL
  module Exporters
    class ServiceExporter < Exporter
      def export_service_to_file(service, path)
        export_to_file path, export_service(service)
      end
    end
  end
end