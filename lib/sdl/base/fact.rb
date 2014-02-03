##
# A fact, which is known about a service.
#
# Facts are defined by using a ServiceCompendium.
class SDL::Base::Fact < SDL::Base::Type
  attr_accessor :service

  class << self
    ##
    # Returns the possible keywords to instantiate this fact class
    # @return [<String>]
    def keywords
      is_form = "is_#{local_name.underscore.verb.conjugate(:tense => :past, :person => :third, :plurality => :singular, :aspect => :perfective)}"
      has_form = "has_#{local_name.underscore}"
      simple_form = local_name.underscore

      [has_form, simple_form, is_form]
    end
  end

  def parent
    service
  end
end