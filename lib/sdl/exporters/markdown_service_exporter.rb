class SDL::Exporters::MarkdownServiceExporter < SDL::Exporters::ServiceExporter
  def export_service(service)
    buf = StringIO.new

    buf.puts I18n.t('sdl.markdown.header')

    service.facts.each do |fact|
      indent = 0

      unless fact.class.documentation.empty?
        buf.puts "* #{fact.class.documentation}"

        indent = 2
      end

      buf.puts "#{'  '* indent}* #{fact.documentation}#{fact.annotated? ? " (#{fact.annotations.join(', ')})" : ''}"
    end

    buf.string
  end

  def export_property_descriptions(property_holder, indentation = 0, buf)
    property_holder.property_values.each do |property, value|
      buf.puts("#{' '*indentation}* #{property.documentation}")
    end
  end
end