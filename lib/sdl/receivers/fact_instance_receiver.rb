module SDL
  module Receivers
    class FactInstanceReceiver
      attr_accessor :instance

      def initialize(instance)
        @instance = instance

        instance.class.properties(true).each do |model_attr|
          define_singleton_method model_attr.name do |value|
            instance.send "#{model_attr.name}=", value
          end
        end
      end
    end
  end
end