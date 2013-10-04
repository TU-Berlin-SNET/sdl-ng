module SDL
  module Types
    class SDLDescription < SDLDefaultType
      include SDLType

      wraps String
      codes :description
    end
  end
end