module SDL
  module Base
    class Type
      include SDL::Base::Properties

      class << self
        attr_accessor :namespace, :local_name
      end

      def receiver
        SDL::Receivers::FactTypeInstanceReceiver.new(self)
      end
    end
  end
end