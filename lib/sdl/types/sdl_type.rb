##
# An SDLType is a wrapper around a basic Ruby type
module SDL::Types::SDLType
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    ##
    # The Ruby type, which is to be wrapped
    #
    # @return Class
    attr :wrapped_type

    ##
    # The codes, which are to be used to refer to this type
    #
    # @return [Symbol]
    attr :codes

    ##
    # Sets the wrapped Ruby type
    # @param type Class
    def wraps(type)
      @wrapped_type = type
    end

    ##
    # Adds the +symbols+ to be used to refer to this type to the list
    # of codes and returns them.
    # @param [Array<Symbol>] *symbols the symbols to be used
    # @return [Array<Symbol>] all resulting symbols
    def codes(*symbols)
      @codes ||= []
      symbols.each do |symbol| @codes << symbol end
      @codes
    end
  end
end