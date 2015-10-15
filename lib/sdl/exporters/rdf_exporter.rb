require 'rdf'
require 'rdf/rdfxml'

class SDL::Exporters::RDFExporter < SDL::Exporters::ServiceExporter
  def export_service(service)
    graph = RDF::Graph.new

    self.class.expand_properties(service, graph)

    graph.dump(:rdf)
  end

  def self.expand_properties(type_instance, graph)
    unless type_instance.class.rdf_type.nil?
      graph << [RDF::URI.new(type_instance.uri), RDF.type, type_instance.class.rdf_type]
    end

    type_instance.property_values.each do |property, value|
      [value].flatten.each do |v|
        graph << [RDF::URI.new(type_instance.uri), property.rdf_url, v.rdf_object] unless v.nil?
      end

      if property.type < SDL::Base::Type
        [value].flatten.each do |v| expand_properties(v, graph) end
      end
    end
  end
end