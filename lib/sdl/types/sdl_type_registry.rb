module SDL
  module Types
    def self.registry
      @registry ||= SDLTypeRegistry.new
    end

    private
      ##
      # The SDLTypeRegistry class
      class SDLTypeRegistry
        attr :code_type_map

        def initialize
          @code_type_map = {}
        end

        def [](code)
          @code_type_map[code]
        end

        def []=(key, value)
          @code_type_map[key] = value
        end
      end
  end
end