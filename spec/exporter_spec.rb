require_relative 'spec_helper'
require_relative 'shared_test_compendium'

require 'rspec'

describe 'The exporters' do
  include_context 'the default compendium'

  let :xsd_exporter do
    SDL::Exporters::XSDSchemaExporter.new
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

  context 'The RDF exporter' do
    it 'creates valid RDF documents' do
      compendium.services.each do |name, service|
        rdf_export = service.to_rdf

        RDF::RDFXML::Reader.new(rdf_export, :validate => true) do |reader|
          expect(reader.valid?)
        end
      end
    end
  end

  context 'The exported files' do
    it 'contains the XSD export' do
      file = Tempfile.new('export.xsd')
      xsd_export = xsd_exporter.export_schema

      begin
        xsd_exporter.export_schema_to_file file.path
        expect(file.read).to eq xsd_export
      ensure
        file.close
        file.unlink
      end
    end

    it 'contains XML export' do
      compendium.services.each do |name, service|
        file = Tempfile.new("#{name}.xml")
        xml_export = service.to_xml

        begin
          SDL::Exporters::XMLServiceExporter.new.export_service_to_file(service, file.path)
          expect(file.read).to eq xml_export
        ensure
          file.close
          file.unlink
        end
      end
    end
  end
end