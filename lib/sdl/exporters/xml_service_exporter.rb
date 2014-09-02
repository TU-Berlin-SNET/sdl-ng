class SDL::Exporters::XMLServiceExporter < SDL::Exporters::ServiceExporter
  def export_service(service)
    builder = Nokogiri::XML::Builder.new do |xml|
      build_service(service, xml)
    end

    builder.to_xml
  end

  def service_xml_attributes(service)
    {
        'xmlns' => 'http://www.open-service-compendium.org',
        'uri' => service.uri
    }
  end

  def build_service(service, xml)
    xml.service(service_xml_attributes(service)) do
      serialize_type_instance service, xml
    end
  end

  def serialize_type_instance(type_instance, xml)
    type_instance.property_values.each do |property, value|
      [value].flatten.each do |v|
        xml.send(property.xsd_element_name + '_', v.xml_attributes) do
          if v.class < SDL::Base::Type
            serialize_type_instance(v, xml)
          else
            xml.text v.xml_value
          end
        end
      end
    end
  end
end