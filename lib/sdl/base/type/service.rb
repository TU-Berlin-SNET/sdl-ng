class SDL::Base::Type::Service < SDL::Base::Type
  class << self
    def unregister

    end
  end

  def to_xml
    SDL::Exporters::XMLServiceExporter.new.export_service(self)
  end

  def to_rdf
    SDL::Exporters::RDFExporter.new.export_service(self)
  end
end