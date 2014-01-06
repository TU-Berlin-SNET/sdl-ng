module SDL
  module Types
    class SDLString < SDLSimpleType
      include SDLType

      wraps String
      codes :string, :str
    end
  end
end