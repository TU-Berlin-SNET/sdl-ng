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

        def xsd_type_identifier_name
          "#{local_name}Identifier"
        end

        def xsd_type_name
          local_name
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

      def xml_value
        self
      end

      def xml_attributes
        attributes = {}

        if respond_to?(:identifier) && identifier
          attributes['identifier'] = identifier
        end

        unless annotations.blank?
          attributes['annotation'] = annotations.first
        end

        attributes
      end
    end

    class SDL::Types::SDLNumber < SDL::Types::SDLSimpleType
      def self.xml_type
        'ns:decimal'
      end
    end

    class SDL::Types::SDLBoolean < SDL::Types::SDLSimpleType
      def self.xml_type
        'ns:boolean'
      end
    end

    class SDL::Types::SDLUrl < SDL::Types::SDLSimpleType
      def self.xml_type
        'ns:anyURI'
      end
    end

    class SDL::Types::SDLMoney < SDL::Types::SDLSimpleType
      def xml_value
        raw_value
      end
    end
  end
end