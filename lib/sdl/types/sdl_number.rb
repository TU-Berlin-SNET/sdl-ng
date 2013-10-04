module SDL
  module Types
    class SDLNumber < SDLDefaultType
      include SDLType

      wraps Integer
      codes :number, :int, :integer
    end
  end
end