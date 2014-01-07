class SDL::Exporters::XMLServiceExporter < ServiceExporter
  def export_service(service)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.service('xmlns' => 'http://www.open-service-compendium.org') do
        service.facts.each do |fact|
          xml.send(fact.class.xsd_element_name + '_') do
            serialize_type_instance fact, xml
          end
        end
      end
    end

    builder.to_xml
  end

  def serialize_type_instance(type_instance, xml)
    type_instance.property_values.each do |property, value|
      [value].flatten.each do |v|
        if v.class < SDL::Base::Type
          xml.send(property.xsd_element_name + '_', (!value.is_a?(Array) && value.identifier) ? {'identifier' => value.identifier.to_s} : {}) do
            v.annotations.each do |annotation|
              xml.annotation annotation
            end
            xml.documentation v.documentation if (!value.is_a?(Array) && value.identifier)
            serialize_type_instance(v, xml)
          end
        else
          xml.send(property.xsd_element_name + '_', v)
        end
      end
    end
  end
end