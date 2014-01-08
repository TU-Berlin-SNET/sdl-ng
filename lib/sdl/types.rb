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
    autoload :SDLType
    autoload :SDLSimpleType

    %w[datetime description duration number string url].each do |typefile|
      ActiveSupport::Dependencies::Loadable.require_dependency File.join(__dir__, 'types', "sdl_#{typefile}.rb")
    end

    autoload :SDLDescription
    autoload :SDLDuration
    autoload :SDLNumber
    autoload :SDLUrl
  end
end