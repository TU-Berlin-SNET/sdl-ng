class ModelAttribute
  attr :name
  attr :type

  def initialize(name, type)
    @name = name.to_s
    @type = type
  end
end