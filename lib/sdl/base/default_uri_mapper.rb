module SDL::Base
  ##
  # Simple implementation of a default URI mapper.
  module DefaultURIMapper
    DEFAULT_BASE_URI = 'http://www.open-service-compendium.org'

    def self.uri(object)
      case object
        when Type.class
          "#{DEFAULT_BASE_URI}/types/#{object.local_name}"
        when Type::Service
          "#{DEFAULT_BASE_URI}/services/#{object.identifier}"
        when Type
          if object.identifier
            "#{object.class.uri}/#{object.identifier.to_s}"
          else
            "#{object.parent.uri}/#{object.class.local_name}/#{object.parent_index}"
          end
        else
          raise "Cannot infer URI of object: #{object}"
      end
    end
  end
end