module SDL::Base
  ##
  # Simple implementation of a default URI mapper.
  module DefaultURIMapper
    DEFAULT_BASE_URI = 'http://www.open-service-compendium.org'

    def self.uri(object)
      case object
        when Type.class
          "#{DEFAULT_BASE_URI}/types/#{object.local_name}"
        when Type
          object.class.uri + '/' + object.hash.to_s
        when Fact
          "#{object.service.uri}/#{object.class.local_name.underscore}-#{object.hash}"
        when Service
          "#{DEFAULT_BASE_URI}/services/#{object.symbolic_name}"
        else
          raise "Cannot infer URI of object: #{object}"
      end
    end
  end
end