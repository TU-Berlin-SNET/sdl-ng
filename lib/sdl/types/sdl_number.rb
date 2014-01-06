module SDL
  module Types
    class SDLNumber < SDLSimpleType
      include SDLType

      wraps Numeric
      codes :number, :int, :integer
    end
  end
end