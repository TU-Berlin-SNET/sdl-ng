require 'nokogiri'
require 'open-uri'

module SDL
  module Receivers
    class ServiceReceiver
      def fetch_from_url(url, *search)
        begin
          doc = Nokogiri::HTML(open(url))

          doc.search(*search)
        rescue SocketError => e
          []
        end
      end
    end
  end
end