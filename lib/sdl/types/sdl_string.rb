class SDL::Types::SDLString < SDL::Types::SDLSimpleType
  include SDL::Types::SDLType

  wraps String
  codes :string, :str

  def from_symbol(sym)
    begin
      @value = sym.to_s
    end
  end
end