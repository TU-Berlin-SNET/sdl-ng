module SDL
  module Base
    class Type
      include SDL::Base::Properties

      class << self
        attr_accessor :namespace, :local_name
      end
    end
  end
end