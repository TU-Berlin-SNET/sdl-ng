require 'active_support/duration'

module SDL
  module Types
    class SDLDuration
      include SDLType

      default_type
      wraps ActiveSupport::Duration
      codes :duration
    end
  end
end