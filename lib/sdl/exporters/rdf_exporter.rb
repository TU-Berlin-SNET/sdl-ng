require 'rdf'
require 'rdf/rdfxml'

class SDL::Exporters::RDFExporter < SDL::Exporters::ServiceExporter
  @@s = RDF::Vocabulary.new('http://www.open-service-compendium.org/')

  def export_service(service)
    graph = RDF::Graph.new

    service.facts.each do |fact|
      graph << [RDF::URI.new(service.uri), @@s["has_#{fact.class.local_name.underscore}"], RDF::URI.new(fact.uri)]

      expand_properties(fact, graph)
    end

    graph.dump(:rdf)
  end

  def expand_properties(type_instance, graph)
    type_instance.property_values.each do |property, value|
      [value].flatten.each do |v|
        graph << [RDF::URI.new(type_instance.uri), @@s["#{property.name.underscore}"], v.rdf_object] unless v.nil?
      end

      if property.type < SDL::Base::Type
        [value].flatten.each do |v| expand_properties(v, graph) end
      end
    end
  end
end

class SDL::Base::Service
  def to_rdf
    SDL::Exporters::RDFExporter.new(@compendium).export_service(self)
  end
end