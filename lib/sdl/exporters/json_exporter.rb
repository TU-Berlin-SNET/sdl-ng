class SDL::Exporters::JSONExporter < SDL::Exporters::ServiceExporter
  ActiveSupport::Dependencies::Loadable.require_dependency File.join(__dir__, 'json_mapping.rb')

  def export_service(service)
    service.to_json
  end
end