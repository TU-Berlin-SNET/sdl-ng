module SDL
  module Receivers
    class FactInstanceReceiver
      attr_accessor :instance

      def initialize(instance)
        @instance = instance

        instance.class.properties(true).each do |property|
          define_singleton_method property.name do |value = nil, &block|
            instance.send "#{property.name}=", block != nil ? SDL::Receivers::PropertyValueReceiver.new(property).instance_exec(&block) : value
          end
        end
      end
    end
  end
end