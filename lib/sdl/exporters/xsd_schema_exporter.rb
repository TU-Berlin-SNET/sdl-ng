require 'active_support/inflector'
require 'nokogiri'

module SDL
  module Exporters
    ##
    # The XSD schema exporter creates an XML Schema Definition for consuming service descriptions using the XML provided
    # by the XMLServiceExporter.
    #
    # The schema consists of the following main components:
    #   - The definition of the root node, i.e., a service. The service contains an arbitrary number of elements of
    #     service fact types.
    #   - The definition of service fact classes and SDL types
    #   - The definition of a type base, containing annotations and documentation
    class XSDSchemaExporter < SchemaExporter
      def export_schema
        export_schema_xml.to_xml
      end

      def export_schema_xml
        Nokogiri::XML::Builder.new do |xml|
          xml['ns'].schema('xmlns' => 'http://www.open-service-compendium.org', 'targetNamespace' => 'http://www.open-service-compendium.org', 'xmlns:ns' => 'http://www.w3.org/2001/XMLSchema', 'elementFormDefault' => 'qualified') do
            xml['ns'].element :name => 'service' do
              document(xml, I18n.t('sdl.xml.service_root'))
              xml['ns'].complexType do
                xml['ns'].choice :maxOccurs => 'unbounded' do
                  @compendium.fact_classes.each do |fact_class|
                    xml['ns'].element :name => fact_class.xsd_element_name, :type => fact_class.xsd_type_name do
                      document(xml, fact_class.documentation)
                    end
                  end
                end
              end
            end

            xml['ns'].complexType :name => 'SDLTypeBase' do
              document(xml, I18n.t('sdl.xml.typebase'))
              xml['ns'].choice do
                xml['ns'].element :name => 'documentation', :minOccurs => 0, :maxOccurs => 'unbounded', :type => 'ns:string' do
                  document(xml, I18n.t('sdl.xml.documentation'))
                end
                xml['ns'].element :name => 'annotation', :minOccurs => 0, :maxOccurs => 'unbounded', :type => 'ns:string' do
                  document(xml, I18n.t('sdl.xml.annotation'))
                end
              end
              xml['ns'].attribute :name => 'identifier' do
                document(xml, I18n.t('sdl.xml.identifier'))
              end
            end

            (@compendium.fact_classes + @compendium.types).each do |fact_class|
              xml['ns'].complexType :name => fact_class.xsd_type_name do
                document(xml, fact_class.documentation)
                xml['ns'].complexContent do
                  xml['ns'].extension :base => fact_class.is_sub? ? fact_class.superclass.xsd_type_name : 'SDLTypeBase' do
                    unless fact_class.properties.empty?
                      xml['ns'].sequence do
                        fact_class.properties.each do |property|
                          extend_property(property, xml) do
                            document(xml, property.documentation)
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      # Creates an xml element corresponding to the SDL property
      def extend_property(property, xml)
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

      # Shortcut for adding an XSD documentation annotation
      def document(xml, documentation)
        xml['ns'].annotation do
          xml['ns'].documentation documentation
        end
      end
    end
  end
end