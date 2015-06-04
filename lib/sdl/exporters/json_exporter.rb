class SDL::Exporters::JSONExporter < SDL::Exporters::ServiceExporter
  def export_service(service)
    service.to_json
  end
end