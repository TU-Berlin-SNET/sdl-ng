class SDL::Types::SDLDescription < SDL::Types::SDLSimpleType
  include SDL::Types::SDLType

  wraps String
  codes :description

  def from_nilclass(nilvalue)
    @value = ""
  end
end