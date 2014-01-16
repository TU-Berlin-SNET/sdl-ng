require_relative 'spec_helper'
require_relative 'shared_test_compendium'

require 'rspec'

describe 'The exporters' do
  include_context 'the default compendium'

  let :xsd_exporter do
    SDL::Exporters::XSDSchemaExporter.new(compendium)
  end

  let :schema do
    xsd_exporter.export_schema
  end

  let :parsed_schema do
    Nokogiri::XML::Schema(schema)
  end

  context 'The XSD exporter' do
    it 'creates a valid XML Schema Definition' do
      expect {
        parsed_schema
      }.to_not raise_exception
    end
  end

  context 'The XML exporter' do
    it 'creates valid XML documents according to the schema' do
      compendium.services.each do |name, service|
        xml_export = service.to_xml

        errors = parsed_schema.validate(Nokogiri::XML::Document.parse(xml_export))

        expect(errors).to be_empty
      end
    end
  end
end