module SDL
  module Receivers
    class FactReceiver < TypeReceiver
      def base_class
        SDL::Base::Fact
      end

      def register_sdltype(type)
        false
      end

      alias :subfact :subtype
    end
  end
end