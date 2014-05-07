class SDL::Types::SDLTime < SDL::Types::SDLSimpleType
  include SDL::Types::SDLType

  wraps Time
  codes :time
end