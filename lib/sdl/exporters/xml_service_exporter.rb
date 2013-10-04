module SDL
  module Exporters
    class XMLServiceExporter < ServiceExporter
      def export_service(service)
        builder = Nokogiri::XML::Builder.new do |xml|

        end
      end
    end
  end
end