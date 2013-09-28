module SDL
  module Types
    ##
    # An SDLType is a wrapper around a basic Ruby type
    module SDLType
      def self.included(base)
        base.class_eval do
          ## The Ruby type, which is to be wrapped
          attr :wrapped_type

          ## The codes, which are to be used to refer to this type
          attr :codes

          ##
          # Sets the wrapped Ruby type
          def self.wraps(type)
            @wrapped_type = type
          end

          ##
          # Registers the codes +syms+ to be used to refer to this type
          def self.codes(*symbols)
            @codes = symbols
          end

          ##
          # Designates this SDLType to be a default type, i.e., to be loaded by all ServiceCompendiums automatically
          def self.default_type
            SDL::Base::ServiceCompendium.default_sdltypes << self
          end
        end
      end
    end
  end
end