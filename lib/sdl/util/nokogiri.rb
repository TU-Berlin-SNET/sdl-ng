require 'nokogiri'
require 'open-uri'

module SDL
  module Util
    module NokogiriUtils
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

module SDL
  module Receivers
    [FactReceiver, ServiceReceiver, TypeInstanceReceiver, TypeReceiver].each do |r|
      r.class_eval do
        include(SDL::Util::NokogiriUtils)
      end
    end
  end
end