require 'slim'

class SDL::Exporters::HTML::HTMLExporter < SDL::Exporters::SchemaExporter
  def export_schema
    Slim::Template.new(File.join(__dir__, 'html_export.slim'), {:pretty => true}).render(SDL::Base::ServiceCompendium.instance, {})
  end
end