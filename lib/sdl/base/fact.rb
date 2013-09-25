module SDL
  module Base
    ##
    # A fact, which is known about a service.
    #
    # Facts are defined by using a ServiceCompendium.
    class Fact
      include SDL::Base::Properties

      class << self
        ## The namespace URL of this Fact class
        attr_accessor :namespace

        ##
        # The local name of the fact, e.g. "Name" or "ServiceInterface".
        #
        # The ServiceCompendium#register_classes_globally method makes this class accessible by a constant of this name
        attr_accessor :local_name
      end

      ##
      # Returns the #FactInstanceReceiver for this Fact instance.
      #
      # The Receiver is used within the definition of a Service to state that this fact is known about the Service.
      def receiver
        FactInstanceReceiver.new(self)
      end
    end
  end
end