require 'rdf'

SDL::Types::SDLSimpleType.class_eval do
  def rdf_object
    RDF::Literal.new(self)
  end
end

module SDL
  module Base
    class Type
      def rdf_object
        RDF::URI.new(uri)
      end
    end
  end
end