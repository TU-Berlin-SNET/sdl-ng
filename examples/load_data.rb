require_relative '../lib/sdl'
require 'active_support'
require 'i18n'

I18n.load_path << File.join(__dir__, 'translations', 'en.yml')

compendium = SDL::Base::ServiceCompendium.new

# Load SDL
Dir.glob(File.join(__dir__, '**', '*.sdl.rb')) do |filename|
  compendium.facts_definition do
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
  File.open(__dir__ + "/rdf_output/#{name}.rdf", 'w') do |f|
    f.write rdf_exporter.export_service(service)
  end
end

all_needed_translations = {
    'en' => {
        'sdl' => I18n.backend.instance_eval{translations}[:en][:sdl]
    }
}

def returning(value)
  yield(value)
  value
end

def convert_hash_to_ordered_hash_and_sort(object, deep = false)
# from http://seb.box.re/2010/1/15/deep-hash-ordering-with-ruby-1-8/
  if object.is_a?(Hash)
    # Hash is ordered in Ruby 1.9!
    res = returning(RUBY_VERSION >= '1.9' ? Hash.new : ActiveSupport::OrderedHash.new) do |map|
      object.each {|k, v| map[k] = deep ? convert_hash_to_ordered_hash_and_sort(v, deep) : v }
    end
    return res.class[res.sort {|a, b| a[0].to_s <=> b[0].to_s } ]
  elsif deep && object.is_a?(Array)
    array = Array.new
    object.each_with_index {|v, i| array[i] = convert_hash_to_ordered_hash_and_sort(v, deep) }
    return array
  else
    return object
  end
end

File.open(__dir__ + "/translations/en.out.yml", 'w') do |f|
  f.write(convert_hash_to_ordered_hash_and_sort(all_needed_translations.deep_stringify_keys!, true).to_yaml)
end

puts 'Finished'