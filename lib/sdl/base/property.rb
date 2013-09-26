module SDL
  module Base
    ##
    # A property of a Fact or Type. It has a #name and an associated Type.
    class Property
      # The Property name
      attr :name

      # The Property Type
      attr :type

      # Is this Property multi-valued
      attr :multi

      # Define a property by its name and type
      def initialize(name, type, multi = false)
        @name = name.to_s
        @type = type
        @multi = multi
      end
    end
  end
end