module SDL
  module Base
    class Type
      ##
      # Gets the values of all properties
      def property_values
        Hash[self.class.properties(true).map{|p| [p, send(p.name)]}]
      end

      class << self
        ## The namespace URL of this Fact class
        attr_accessor :namespace

        ##
        # The local name of the fact, e.g. "Name" or "ServiceInterface".
        #
        # The ServiceCompendium#register_classes_globally method makes this class accessible by a constant of this name
        attr_accessor :local_name

        def to_s
          @local_name
        end

        def properties(including_super = false)
          if including_super && is_sub?
            self.properties + superclass.properties(true)
          else
            @properties ||= []
          end
        end

        def is_sub?
          not [SDL::Base::Type, SDL::Base::Fact].include? superclass
        end
      end

      def to_s
        # TODO Description of the meaning of facts
        self.class.to_s
      end

      def annotations
        @annotations ||= []
      end
    end
  end
end