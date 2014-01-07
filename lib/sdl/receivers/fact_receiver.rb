class SDL::Receivers::FactReceiver < SDL::Receivers::TypeReceiver
  def base_class
    SDL::Base::Fact
  end

  def register_sdltype(type)
    false
  end

  alias :subfact :subtype
end