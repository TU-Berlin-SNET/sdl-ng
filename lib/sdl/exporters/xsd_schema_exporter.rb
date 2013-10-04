require 'active_support/inflector'
require 'nokogiri'

module SDL
  module Base
    class Type
      class << self
        def xsd_type_name
          local_name
        end
      end
    end
  end

  module Types
    module SDLType
      module ClassMethods
        def xml_type
          if self < SDL::Base::Type
            wrapped_type.xsd_type_name
          else
            'ns:string'
          end
        end
      end
    end
  end

  module Exporters
    class XSDSchemaExporter < SchemaExporter
      def export_schema
        builder = Nokogiri::XML::Builder.new do |xml|
          xml['ns'].schema('xmlns:ns' => 'http://www.w3.org/2001/XMLSchema') do
            (@compendium.fact_classes + @compendium.types).each do |fact_class|
              xml['ns'].complexType :name => fact_class.xsd_type_name do
                extend_if_sub(fact_class, xml) do
                  unless fact_class.properties.empty?
                    xml['ns'].sequence do
                      fact_class.properties.each do |property|
                        xml['ns'].element :name => property.name, :type => property.type.xml_type
                      end
                    end
                  end
                end
              end
            end

            xml['ns'].element :name => 'service' do
              xml['ns'].complexType do
                xml['ns'].sequence :maxOccurs => 'unbounded' do
                  xml['ns'].choice do
                    @compendium.fact_classes.each do |fact_class|
                      xml['ns'].element :name => fact_class.local_name.camelize(:lower), :type => fact_class.xsd_type_name
                    end
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