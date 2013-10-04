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

exporter = SDL::Exporters::XSDSchemaExporter.new(compendium)

File.open(__dir__ + '/xml_output/schema.xsd', 'w') {|f| f.write(exporter.export) }