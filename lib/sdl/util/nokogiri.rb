require 'nokogiri'
require 'open-uri'

module SDL
  module Receivers
    class ServiceReceiver
      def fetch_from_url(url, *search)
        doc = Nokogiri::HTML(open(url))

        doc.search(*search)
      end
    end
  end
end