module SDL
  ##
  # This module contains the base classes of the \SDL Framework.
  #
  # These include:
  # Fact::      A fact about a service
  # Service::   A service, which is described through facts
  # Type::      A type used in service descriptions
  # Property::  A property of a fact or type
  #
  # The ServiceCompendium is used for easy definition of new facts, services, types and properties.
  module Base
    extend ActiveSupport::Autoload

    autoload :Fact
    autoload :Property
    autoload :Service
    autoload :ServiceCompendium
    autoload :Type
  end
end