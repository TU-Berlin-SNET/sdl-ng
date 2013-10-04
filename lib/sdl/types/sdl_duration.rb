require 'active_support/duration'

module SDL
  module Types
    class SDLDuration < SDLDefaultType
      include SDLType

      wraps ActiveSupport::Duration
      codes :duration
    end
  end
end