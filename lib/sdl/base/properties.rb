module SDL
  module Base
    ##
    # Module, which adds a properties array to the including class.
    module Properties
      def self.included(base)
        base.class_eval do
          def self.properties(including_super = false)
            if including_super && superclass.respond_to?(:properties)
              self.properties + superclass.properties(true)
            else
              @properties ||= []
            end
          end
        end
      end
    end
  end
end