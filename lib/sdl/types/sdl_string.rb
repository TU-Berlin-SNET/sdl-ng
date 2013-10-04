module SDL
  module Types
    class SDLString < SDLDefaultType
      include SDLType

      wraps String
      codes :string, :str
    end
  end
end