class SDL::Types::SDLBoolean < SDL::Types::SDLSimpleType
  include SDL::Types::SDLType

  wraps Object
  codes :bool, :boolean
end