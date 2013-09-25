module SDL
  module Base
    ##
    # A property of a Fact or Type. It has a #name and an associated Type.
    class Property
      # The Property name
      attr :name

      # The Property Type
      attr :type

      # Define a property by its name and type
      def initialize(name, type)
        @name = name.to_s
        @type = type
      end
    end
  end
end