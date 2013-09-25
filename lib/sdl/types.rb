require_relative 'types/sdl_type_registry'
require_relative 'types/sdl_type'
require_relative 'types/sdl_string'
require_relative 'types/sdl_duration'

module SDL
  ##
  # This module contains the SDL type system.
  #
  # An SDL type is a wrapper around a Ruby type and is used in two contexts:
  # * When setting a property, its new value is checked for type compatibility to the wrapped Ruby class
  # * When exporting a service description, the wrapper is used to determine the serialization format
  module Types
  end
end