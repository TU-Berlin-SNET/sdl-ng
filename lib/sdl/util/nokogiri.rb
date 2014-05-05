require 'nokogiri'
require 'socket'
require 'open-uri'

module SDL
  module Util
    module NokogiriUtils
      ##
      # Fetches an Nokogiri::XML::NodeSet from the webpage at url by performing *search
      #
      def fetch_from_url(url, *search)
        begin
          fetch_from_io open(url), url, *search
        rescue SocketError => e
          []
        end
      end

      def fetch_from_io(io, base_url, *search)
        process_result Nokogiri::HTML(io).search(*search), base_url
      end

      # It converts all relative href URLs to absolute URLs and adds a 'target' attribute to all
      # links, so that they open in a new browser window and not the current broker.
      def process_result(result, base_url)
        result.search('//body//@href').each do |attribute|
          begin
            attribute.content = URI.join(base_url, attribute.value.gsub(/\s/, '')).to_s
          rescue URI::InvalidURIError
            next
          end

          if attribute.parent.name.eql? 'a'
            attribute.parent['target'] = '_new'
          end
        end

        result
      end
    end
  end
end

SDL::Receivers::TypeInstanceReceiver.class_eval do
  include SDL::Util::NokogiriUtils
end