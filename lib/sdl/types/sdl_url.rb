require 'uri'

module SDL
  module Types
    class SDLUrl < SDLSimpleType
      include SDLType

      wraps URI
      codes :uri, :url

      def from_string(string_value)
        begin
          URI.parse string_value
        rescue URI::InvalidURIError
          throw "Invalid URI: #{string_value}"
        end
      end
    end
  end
end