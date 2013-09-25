require_relative 'base/properties'
require_relative 'base/fact'
require_relative 'base/property'
require_relative 'base/type'
require_relative 'base/service'
require_relative 'base/service_compendium'

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
  end
end