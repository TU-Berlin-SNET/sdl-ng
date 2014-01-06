module SDL
  module Types
    class SDLDescription < SDLSimpleType
      include SDLType

      wraps String
      codes :description

      def from_nilclass(nilvalue)
        @value = ""
      end
    end
  end
end