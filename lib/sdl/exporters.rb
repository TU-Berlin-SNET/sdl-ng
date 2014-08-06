module SDL::Exporters
  extend ActiveSupport::Autoload

  autoload :Exporter
  autoload :SchemaExporter
  autoload :ServiceExporter
  autoload :RDFExporter
  autoload :XMLServiceExporter
  autoload :XSDSchemaExporter
  autoload :HTML

  ActiveSupport::Dependencies::Loadable.require_dependency File.join(__dir__, 'exporters', 'xml_mapping.rb')
  ActiveSupport::Dependencies::Loadable.require_dependency File.join(__dir__, 'exporters', 'rdf_mapping.rb')
end