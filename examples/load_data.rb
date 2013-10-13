require_relative '../lib/sdl'

compendium = SDL::Base::ServiceCompendium.new

# Load SDL
Dir.glob(File.join(__dir__, '**', '*.sdl.rb')) do |filename|
  compendium.facts_definition do
    eval(File.read(filename), binding, filename)
  end
end

# Load Types
Dir.glob(File.join(__dir__, '**', '*.sdl-data.rb')) do |filename|
  compendium.type_instances_definition do
    eval(File.read(filename), binding, filename)
  end
end

compendium.register_classes_globally

# Load Service Definitions
Dir.glob(File.join(__dir__, '**', '*.service.rb')) do |filename|
  compendium.service filename.match(%r[.+/(.+).service.rb])[1] do
    eval(File.read(filename), binding, filename)
  end
end

puts compendium

schema_exporter = SDL::Exporters::XSDSchemaExporter.new(compendium)
File.open(__dir__ + '/xml_output/schema.xsd', 'w') {|f| f.write(schema_exporter.export_schema) }

service_exporter = SDL::Exporters::XMLServiceExporter.new(compendium)
compendium.services.each do |name, service|
  File.open(__dir__ + "/xml_output/#{name}.xml", 'w') do |f|
    f.write(service_exporter.export_service(service))
  end
end

xsd = Nokogiri::XML::Schema(File.read(__dir__ + '/xml_output/schema.xsd'))
compendium.services.each do |name, service|
  xsd.validate(Nokogiri::XML(File.read(__dir__ + "/xml_output/#{name}.xml"))).each do |error|
    puts error.message
  end
end

rdf_exporter = SDL::Exporters::RDFExporter.new(compendium)
compendium.services.each do |name, service|
  puts rdf_exporter.export_service service
end