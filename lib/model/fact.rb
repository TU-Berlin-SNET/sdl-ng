require_relative 'model_attributes'

class Fact
  include ModelAttributes

  class << self
    attr_accessor :namespace, :local_name
  end

  def receiver
    FactInstanceReceiver.new(self)
  end

  def attributes
    attributes = {}

    self.model_attributes.each do |attribute|
      attributes[attribute.name] = send(attribute.name)
    end

    attributes
  end
end