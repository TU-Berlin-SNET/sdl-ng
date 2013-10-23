module SDL
  module Types
    class SDLDatetime < SDLDefaultType
      include SDLType

      wraps Time
      codes :datetime
    end
  end
end