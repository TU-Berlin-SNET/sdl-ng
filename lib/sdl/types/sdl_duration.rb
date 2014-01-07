require 'active_support/duration'

class SDL::Types::SDLDuration < SDL::Types::SDLSimpleType
  include SDL::Types::SDLType

  wraps ActiveSupport::Duration
  codes :duration
end