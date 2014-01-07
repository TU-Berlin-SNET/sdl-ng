module SDL
  ##
  # This module contains the SDL type system.
  #
  # An SDL type is a wrapper around a Ruby type and is used in two contexts:
  # * When setting a property, its new value is checked for type compatibility to the wrapped Ruby class
  # * When exporting a service description, the wrapper is used to determine the serialization format
  module Types
    extend ActiveSupport::Autoload

    # Required, as these types register Receiver methods for their usage in property definitions.
    eager_autoload do
      autoload :SDLType
      autoload :SDLSimpleType
      autoload :SDLDatetime
      autoload :SDLDescription
      autoload :SDLDuration
      autoload :SDLNumber
      autoload :SDLString
      autoload :SDLUrl
    end

    eager_load!
  end
end