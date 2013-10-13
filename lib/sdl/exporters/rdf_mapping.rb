require 'rdf'
require 'active_support/inflector'

class String
  def rdf_object
    RDF::Literal.new(self)
  end
end

module Nokogiri
  module XML
    class Element
      def rdf_object
        RDF::Literal.new(self)
      end
    end
  end
end

module SDL
  module Base
    class Fact
      class << self
        def rdf_uri
          "http://www.open-service-compendium.org/#{@local_name}"
        end
      end

      def rdf_uri
        "#{service.rdf_uri}/#{self.class.local_name.underscore}#{hash}"
      end
    end

    class Type
      class << self
        def rdf_uri
          "http://www.open-service-compendium.org/#{@local_name}"
        end
      end

      def rdf_uri
        self.class.rdf_uri + '/' + hash.to_s
      end

      def rdf_object
        RDF::URI.new(rdf_uri)
      end
    end

    class Service
      def rdf_uri
        "http://www.open-service-compendium.org/#{hash}"
      end
    end
  end
end