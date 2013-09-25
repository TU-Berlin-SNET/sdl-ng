module SDL
  module Types
    class SDLString
      include SDLType

      wraps String
      codes :string, :str
    end
  end
end