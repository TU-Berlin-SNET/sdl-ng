module AttributeDefinitions
  def self.included(base)
    base.class_eval do
      def self.define_attributes_for(sym)
        @target_class = sym
      end
    end
  end

  def list(sym, &attribute_definition)
    model_attribute = ModelAttribute.new(sym, Array)

    receiver = ModelAttributeReceiver.new(model_attribute)
    receiver.instance_eval &attribute_definition if block_given?

    target_class.model_attributes << model_attribute
  end

  def string(sym)
    simple_type sym, String
  end

  def number(sym)
    simple_type sym, Numeric
  end

  def duration(sym)

  end

  def simple_type(sym, type)
    target_class.class_eval do
      attr_accessor sym

      model_attributes << ModelAttribute.new(sym, type)
    end
  end

  def method_missing(name, *args, &block)
    if name =~ /list_of_/ then
      list(args[0], &block)
    else
      super(name, *args, &block)
    end
  end

  def target_class
    send self.class.instance_variable_get('@target_class')
  end
end