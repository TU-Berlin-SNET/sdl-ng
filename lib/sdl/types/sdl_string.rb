class SDL::Types::SDLString < SDL::Types::SDLSimpleType
  include SDL::Types::SDLType

  wraps String
  codes :string, :str
end