require 'money'
require 'monetize'

class SDL::Types::SDLMoney < SDL::Types::SDLSimpleType
  include SDL::Types::SDLType

  wraps Money
  codes :money

  def from_string(string_value)
    begin
      @value = Monetize.parse(string_value)
    rescue ArgumentError
      throw "Invalid Money value: #{string_value}"
    end
  end
end