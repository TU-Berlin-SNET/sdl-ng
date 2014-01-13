class SDL::Exporters::SchemaExporter < SDL::Exporters::Exporter
  def export_schema_to_file(path)
    export_to_file path, export_schema
  end
end