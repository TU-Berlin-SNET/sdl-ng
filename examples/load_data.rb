require_relative '../lib/service_compendium'

compendium = ServiceCompendium.new

# Load SDL
Dir.glob(File.join(__dir__, '**', '*.sdl.rb')) do |filename|
  compendium.facts_definition do
    eval(File.read(filename), binding, filename)
  end
end

# Load Service Definitions
Dir.glob(File.join(__dir__, '**', '*.service.rb')) do |filename|
  compendium.service filename.match(%r[.+/(.+).service.rb])[1] do
    eval(File.read(filename), binding, filename)
  end
end

compendium.register_classes_globally