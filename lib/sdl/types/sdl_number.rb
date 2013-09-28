module SDL
  module Types
    class SDLNumber
      include SDLType

      default_type
      wraps Integer
      codes :number, :int, :integer
    end
  end
end