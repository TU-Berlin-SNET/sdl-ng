class SDL::Types::SDLNumber < SDL::Types::SDLSimpleType
  include SDL::Types::SDLType

  wraps Numeric
  codes :number, :int, :integer
end