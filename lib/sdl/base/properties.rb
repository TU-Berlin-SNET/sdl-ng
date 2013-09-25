module SDL
  module Base
    ##
    # Module, which adds a properties array to the including class.
    module Properties
      def self.included(base)
        base.class_eval do
          def self.properties
            @properties ||= []
          end
        end
      end
    end
  end
end