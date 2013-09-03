require_relative 'model_attributes'

class Type
  include ModelAttributes

  class << self
    attr_accessor :namespace, :local_name
  end
end