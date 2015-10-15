require 'nokogiri'

##
# The XSD simple schema exporter creates an XML Schema Definition for consuming service
# descriptions using the XML provided by the XMLServiceExporter.
#
# It is different from the XSDSchemaExporter that it does not combine restriction and
# enumeration and therefore prevents challenges with some XSD tools.
#
class SDL::Exporters::XSDSimpleSchemaExporter < SDL::Exporters::SchemaExporter
  def export_schema
    export_schema_xml.to_xml
  end

  def export_schema_xml
    Nokogiri::XML::Builder.new do |xml|
      xml['ns'].schema('xmlns' => 'http://www.open-service-compendium.org', 'targetNamespace' => 'http://www.open-service-compendium.org', 'xmlns:ns' => 'http://www.w3.org/2001/XMLSchema', 'elementFormDefault' => 'qualified') do
        xml['ns'].element :name => 'services' do
          document(xml, I18n.t('sdl.xml.services_root'))
          xml['ns'].complexType do
            xml['ns'].sequence do
              xml['ns'].element :name=> 'service', :type => 'Service', :minOccurs => 0, :maxOccurs => :unbounded
            end
          end
        end

        xml['ns'].element :name => 'service', :type => 'Service' do
          document(xml, I18n.t('sdl.xml.service_root'))
        end

        xml['ns'].complexType :name => 'SDLTypeBase', :abstract => true do
          document(xml, I18n.t('sdl.xml.typebase'))
          xml['ns'].attribute :name => 'annotation', :type => 'ns:string' do
            document(xml, I18n.t('sdl.xml.annotation'))
          end
          xml['ns'].attribute :name => 'uri' do
            document(xml, I18n.t('sdl.xml.identifier'))
          end
        end

        SDL::Base::Type.subtypes_recursive.drop(1).each do |type_class|
          xml['ns'].complexType :name => type_class.xsd_type_name do
            document(xml, type_class.documentation)
            xml['ns'].complexContent do
              xml['ns'].extension :base => "SDLTypeBase" do
                xml['ns'].sequence do
                  type_class.ancestors.select do |c| c < SDL::Base::Type end.each do |ancestor|
                    xml['ns'].group :ref => "#{ancestor.xsd_type_name}Properties"
                  end
                end

                if type_class.eql? SDL::Base::Type::Service
                  build_abstract_service_attributes(xml, type_class)
                  build_service_attributes(xml, type_class)
                else
                  xml['ns'].attribute :name => 'identifier', :type => type_class.xsd_type_identifier_name do
                    document(xml, I18n.t('sdl.xml.identifier'))
                  end unless type_class.instances.empty?
                end
              end
            end
          end

          xml['ns'].group :name => "#{type_class.xsd_type_name}Properties" do
            xml['ns'].sequence do
              type_class.properties.each do |property|
                extend_property(property, xml) do
                  document(xml, property.documentation)
                end
              end
            end
          end

          xml['ns'].simpleType :name => type_class.xsd_type_identifier_name do
            xml['ns'].restriction :base => type_class.is_sub? ? type_class.superclass.xsd_type_identifier_name : 'ns:string' do
              type_class.instances.each do |symbol, instance|
                xml['ns'].enumeration :value => symbol do
                  document(xml, instance.documentation)
                end
              end
            end
          end unless type_class.eql?(SDL::Base::Type::Service) || type_class.instances.empty?
        end

        build_additional_types(xml)
      end
    end
  end

  # Creates an xml element corresponding to the SDL property
  def extend_property(property, xml)
    if property.simple_type?
      xml['ns'].element :name => property.multi? ? property.name.singularize : property.name, :minOccurs => 0, :maxOccurs => property.multi? ? 'unbounded' : 1 do
        yield
        xml['ns'].complexType do
          xml['ns'].simpleContent do
            xml['ns'].extension :base => property.type.xml_type do
              xml['ns'].attribute :name => 'annotation'
            end
          end
        end
      end
    else
      if property.multi?
        xml['ns'].element :name => property.name.singularize, :type => property.type.xml_type, :minOccurs => 0, :maxOccurs => 'unbounded' do
          yield
        end
      else
        xml['ns'].element :name => property.name, :type => property.type.xml_type, :minOccurs => 0 do
          yield
        end
      end
    end
  end

  # Shortcut for adding an XSD documentation annotation
  def document(xml, documentation)
    xml['ns'].annotation do
      xml['ns'].documentation documentation
    end
  end

  def build_abstract_service_attributes(xml, service_class)

  end

  def build_service_attributes(xml, service_class)

  end

  def build_additional_types(xml)

  end
end