require 'rdf'

[String, Fixnum, Nokogiri::XML::Element].each do |klass|
  klass.class_eval do
    def rdf_object
      RDF::Literal.new(self)
    end
  end
end

module SDL
  module Base
    class Fact
      class << self
        def uri
          "http://www.open-service-compendium.org/types/#{@local_name}"
        end
      end

      def uri
        "#{service.uri}/#{self.class.local_name.underscore}-#{hash}"
      end
    end

    class Type
      class << self
        def uri
          "http://www.open-service-compendium.org/types/#{@local_name}"
        end
      end

      def uri
        self.class.uri + '/' + hash.to_s
      end

      def rdf_object
        RDF::URI.new(uri)
      end
    end

    class Service
      def uri
        "http://www.open-service-compendium.org/services/#{@symbolic_name}"
      end
    end
  end
end