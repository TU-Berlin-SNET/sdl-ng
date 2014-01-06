require 'i18n'

module SDL
  module Base
    class Type
      class << self
        ## The namespace URL of this Fact class
        attr_accessor :namespace

        ##
        # The local name of the type, e.g. "Name" or "ServiceInterface". Defaults to the name of the class.
        #
        # The ServiceCompendium#register_classes_globally method makes this class accessible by a constant of this name
        @local_name

        def local_name
          @local_name || name.demodulize
        end

        def local_name=(name)
          @local_name = name
        end

        def to_s
          @local_name || name
        end

        def properties(including_super = false)
          if including_super && is_sub?
            self.properties + superclass.properties(true)
          else
            @properties ||= []
          end
        end

        def propertyless?(including_super = false)
          properties(including_super).count == 0
        end

        def single_property?(including_super = false)
          properties(including_super).count == 1
        end

        def multi_property?(including_super = true)
          properties(including_super).count > 1
        end

        def is_sub?
          not [SDL::Base::Type, SDL::Base::Fact].include? superclass
        end
      end

      ##
      # Gets the values of all properties
      def property_values
        Hash[self.class.properties(true).map{|p| [p, send(p.name)]}]
      end

      def to_s
        # If there is a property with the same name, than the type, return its to_s, return the name of the class
        naming_property = self.class.properties(true).find {|p| p.name.eql?(self.class.to_s.underscore) }

        if(naming_property)
          instance_variable_get("@#{naming_property.name.to_sym}").to_s
        else
          self.class.to_s
        end
      end

      def annotated?
        ! @annotations.blank?
      end

      def annotations
        @annotations ||= []
      end

      # An identifier for type instances
      attr_accessor :identifier
    end
  end
end