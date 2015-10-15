require 'rdf'
require 'rdf/xsd/any_uri'
require 'rdf/vocab/schema'

module SDL::Types
  SDLSimpleType.class_eval do
    def rdf_object
      RDF::Literal.new(raw_value)
    end
  end

  SDLUrl.class_eval do
    def rdf_object
      RDF::Literal::AnyURI.new(raw_value)
    end
  end
end

module SDL
  module Base
    @@rdf_vocabulary = RDF::Vocabulary.new('http://www.open-service-compendium.org/')

    def self.rdf_vocabulary
      @@rdf_vocabulary
    end

    class Type
      def self.map_rdf_property(name, rdf_type)
        property = properties.find {|p| p.name == name}

        if property
          property.define_singleton_method :rdf_url do
            rdf_type
          end
        end
      end

      def self.map_rdf_type(rdf_type)
        self.define_singleton_method :rdf_type do
          rdf_type
        end
      end

      def self.rdf_type
        nil
      end

      def rdf_object
        RDF::URI.new(uri)
      end
    end

    class Property
      def rdf_url
        ::SDL::Base::rdf_vocabulary["#{holder.local_name.underscore}_#{name.underscore}"]
      end
    end
  end
end