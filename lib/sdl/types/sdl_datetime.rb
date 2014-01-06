module SDL
  module Types
    class SDLDatetime < SDLSimpleType
      include SDLType

      wraps Time
      codes :datetime
    end
  end
end