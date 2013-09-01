require_relative '../lib/service_compendium'

compendium = ServiceCompendium.new

Dir.glob(File.join(__dir__, '**', '*.sdl.rb')) do |filename|
  compendium.facts_definition do
    eval(File.read(filename), binding, filename)
  end
end

puts compendium