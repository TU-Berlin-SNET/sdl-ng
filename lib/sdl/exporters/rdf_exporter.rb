require 'rdf'
require 'rdf/rdfxml'

module SDL
  module Exporters
    class RDFExporter < ServiceExporter
      @@s = RDF::Vocabulary.new('http://www.open-service-compendium.org/')

      def export_service(service)
        graph = RDF::Graph.new

        service.facts.each do |fact|
          graph << [RDF::URI.new(service.rdf_uri), @@s["has_#{fact.class.local_name.underscore}"], RDF::URI.new(fact.rdf_uri)]

          expand_properties(fact, graph)
        end

        graph.dump(:rdf)
      end

      def expand_properties(type_instance, graph)
        type_instance.property_values.each do |property, value|
          [value].flatten.each do |v|
            graph << [RDF::URI.new(type_instance.rdf_uri), @@s["#{property.name.underscore}"], v.rdf_object]
          end

          if property.type < SDL::Base::Type
            [value].flatten.each do |v| expand_properties(v, graph) end
          end
        end
      end
    end
  end
end