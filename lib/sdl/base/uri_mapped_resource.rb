##
# An URI mapped resource supports retrieving its URI by its #uri method.
#
# The #uri method retrieves an object, which responds to #uri(object).
#
# It tries to find it using:
#   * #uri_mapper
#   * @uri_mapper
#   * self.uri_mapper
#   * @@uri_mapper
#
# or the DefaultURIMapper as fallback.
module SDL::Base
  module URIMappedResource
    def uri
      if self.respond_to? :uri_mapper
        uri_mapper.uri self
      elsif self.instance_variable_get :@uri_mapper
        @uri_mapper.uri self
      elsif self.class.respond_to? :uri_mapper
        self.class.uri_mapper.uri self
      elsif self.class.instance_variable_get :@uri_mapper
        self.class.instance_variable_get(:@uri_mapper).uri self
      else
        DefaultURIMapper.uri self
      end
    end
  end
end