module SDL::Exporters
  extend ActiveSupport::Autoload

  autoload :Exporter
  autoload :SchemaExporter
  autoload :ServiceExporter
  autoload :RDFExporter
  autoload :XMLServiceExporter
  autoload :XSDSchemaExporter
  autoload :XSDSimpleSchemaExporter
  autoload :JSONExporter
  autoload :JSONSchemaExporter
  autoload :HTML

  ActiveSupport::Dependencies::Loadable.require_dependency File.join(__dir__, 'exporters', 'xml_mapping.rb')
  ActiveSupport::Dependencies::Loadable.require_dependency File.join(__dir__, 'exporters', 'rdf_mapping.rb')
  ActiveSupport::Dependencies::Loadable.require_dependency File.join(__dir__, 'exporters', 'json_mapping.rb')
end