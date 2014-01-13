##
# Description values are extended string values with additional conversion functions.
class SDL::Types::SDLDescription < SDL::Types::SDLSimpleType
  include SDL::Types::SDLType

  wraps String
  codes :description

  def from_nil_class(nilvalue)
    @value = ''
  end

  def from_nokogiri_xml_element(element)
    @value = element.content.squish
  end

  def to_html
    case @raw_value
      when Nokogiri::XML::Element
        @raw_value.to_s
      when NilClass
        ''
      else
        "Cannot convert #{@raw_value.class} to HTML. Please extend SDLDescription#to_html"
    end
  end
end