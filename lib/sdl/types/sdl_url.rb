require 'uri'

module SDL
  module Types
    class SDLUrl < SDLDefaultType
      include SDLType

      wraps URI
      codes :uri, :url
    end
  end
end