require 'active_support/inflector'
require 'nokogiri'

module SDL
  module Exporters
    class XSDSchemaExporter < SchemaExporter
      def export_schema
        builder = Nokogiri::XML::Builder.new do |xml|
          xml['ns'].schema('xmlns' => 'http://www.open-service-compendium.org', 'targetNamespace' => 'http://www.open-service-compendium.org', 'xmlns:ns' => 'http://www.w3.org/2001/XMLSchema', 'elementFormDefault' => 'qualified') do
            (@compendium.fact_classes + @compendium.types).each do |fact_class|
              xml['ns'].complexType :name => fact_class.xsd_type_name do
                extend_if_sub(fact_class, xml) do
                  unless fact_class.properties.empty?
                    xml['ns'].sequence do
                      fact_class.properties.each do |property|
                        if property.multi?
                          xml['ns'].element :name => property.name.singularize, :type => property.type.xml_type, :minOccurs => 0, :maxOccurs => 'unbounded'
                        else
                          xml['ns'].element :name => property.name, :type => property.type.xml_type, :minOccurs => 0
                        end
                      end
                    end
                  end
                end
              end
            end

            xml['ns'].element :name => 'service' do
              xml['ns'].complexType do
                xml['ns'].choice :maxOccurs => 'unbounded' do
                  @compendium.fact_classes.each do |fact_class|
                    xml['ns'].element :name => fact_class.xsd_element_name, :type => fact_class.xsd_type_name
                  end
                end
              end
            end
          end
        end

        builder.to_xml
      end

      # Makes an XSD complexType definition extend a base definition, if the Fact class extends another fact class
      def extend_if_sub(fact_class, xml)
        if fact_class.is_sub?
          xml['ns'].complexContent do
            xml['ns'].extension :base => fact_class.superclass.xsd_type_name do
              yield
            end
          end
        else
          yield
        end
      end
    end
  end
end