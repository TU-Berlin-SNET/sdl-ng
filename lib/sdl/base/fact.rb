module SDL
  module Base
    ##
    # A fact, which is known about a service.
    #
    # Facts are defined by using a ServiceCompendium.
    class Fact < Type
      attr_accessor :service
    end
  end
end
