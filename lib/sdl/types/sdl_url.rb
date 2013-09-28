require 'uri'

module SDL
  module Types
    class SDLUrl
      include SDLType

      default_type
      wraps URI
      codes :uri, :url
    end
  end
end