class SDL::Exporters::Exporter
  attr :options

  def initialize(options = {})
    @options = options
  end

  def export_to_file(path, content)
    File.open(path, 'w') do |f|
      f.write(content)
    end
  end
end