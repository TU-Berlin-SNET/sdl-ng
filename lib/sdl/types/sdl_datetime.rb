class SDL::Types::SDLDatetime < SDL::Types::SDLSimpleType
  include SDL::Types::SDLType

  wraps Time
  codes :datetime
end