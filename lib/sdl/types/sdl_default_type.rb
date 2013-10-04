module SDL
  module Types
    class SDLDefaultType
      include SDLType

      ##
      # Designates this SDLType to be a default type, i.e., to be loaded by all ServiceCompendiums automatically
      def self.inherited(subclass)
        SDL::Base::ServiceCompendium.default_sdltypes << subclass
      end
    end
  end
end