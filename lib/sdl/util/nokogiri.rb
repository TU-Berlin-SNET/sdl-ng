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

SDL::Receivers::Receiver.class_eval do
  include(SDL::Util::NokogiriUtils)
end