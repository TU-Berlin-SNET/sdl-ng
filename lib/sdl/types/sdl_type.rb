##
# An SDLType is a wrapper around a basic Ruby type
module SDL::Types::SDLType
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    ## The Ruby type, which is to be wrapped
    attr :wrapped_type

    ## The codes, which are to be used to refer to this type
    attr :codes

    ##
    # Sets the wrapped Ruby type
    def wraps(type)
      @wrapped_type = type
    end

    ##
    # Registers the codes +symbols+ to be used to refer to this type
    def codes(*symbols)
      @codes = symbols
    end
  end
end