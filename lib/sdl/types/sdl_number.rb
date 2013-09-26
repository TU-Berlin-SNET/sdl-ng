module SDL
  module Types
    class SDLNumber
      include SDLType

      wraps Integer
      codes :number, :int, :integer
    end
  end
end