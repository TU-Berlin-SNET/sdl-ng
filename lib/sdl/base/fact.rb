##
# A fact, which is known about a service.
#
# Facts are defined by using a ServiceCompendium.
class SDL::Base::Fact < SDL::Base::Type
  attr_accessor :service
end