module SDL
  module Types
    ##
    # An SDLType is a wrapper around a basic Ruby type
    module SDLType
      def self.included(base)
        base.class_eval do
          ## The Ruby type, which is to be wrapped
          attr :wrapped_type

          ##
          # Sets the wrapped Ruby type
          def self.wraps(type)
            @wrapped_type = type
          end

          ##
          # Registers the codes +syms+ to be used to refer to this type
          def self.codes(*symbols)
            symbols.each do |sym|
              SDL::Types.registry[sym] = self
            end
          end
        end
      end
    end
  end
end