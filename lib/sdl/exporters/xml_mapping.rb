module SDL
  module Base
    class Property
      def xsd_element_name
        if multi?
          @name.singularize
        else
          @name
        end
      end
    end

    class Type
      class << self
        def xsd_element_name
          local_name.camelize(:lower)
        end

        def xsd_type_name
          local_name
        end
      end
    end

    class Fact
      class << self
        def xsd_type_name
          "#{local_name}Fact"
        end
      end
    end
  end

  module Types
    module SDLType
      module ClassMethods
        def xml_type
          if self < SDL::Base::Type
            wrapped_type.xsd_type_name
          else
            'ns:string'
          end
        end
      end
    end
  end
end