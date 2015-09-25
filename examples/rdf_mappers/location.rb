require 'rdf/vocab/schema'
require 'sdl/exporters/rdf_mapping'

class SDL::Base::Type::Location
  map_rdf_type(RDF::SCHEMA.PostalAddress)

  map_rdf_property('name', RDF::SCHEMA.name)
  map_rdf_property('country_code', RDF::SCHEMA.addressCountry)
  map_rdf_property('region', RDF::SCHEMA.addressRegion)
  map_rdf_property('locality', RDF::SCHEMA.addressLocality)
  map_rdf_property('po_number', RDF::SCHEMA.postOfficeBoxNumber)
  map_rdf_property('postal_code', RDF::SCHEMA.postalCode)
  map_rdf_property('street_address', RDF::SCHEMA.streetAddress)
end