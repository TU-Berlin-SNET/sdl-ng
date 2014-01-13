require 'nokogiri'
require 'open-uri'

module SDL
  module Util
    module NokogiriUtils
      ##
      # Fetches an Nokogiri::XML::NodeSet from the webpage at url by performing *search
      #
      # Additionally it converts all relative href URLs to absolute URLs and adds a 'target' attribute to all
      # links, so that they open in a new browser window and not the current broker.
      def fetch_from_url(url, *search)
        begin
          doc = Nokogiri::HTML(open(url))

          result = doc.search(*search)

          result.search('//body//@href').each do |attribute|
            begin
              attribute.content = URI.join(url, attribute.value.gsub(/\s/, '')).to_s
            rescue URI::InvalidURIError
              next
            end

            if attribute.parent.name.eql? 'a'
              attribute.parent['target'] = '_new'
            end
          end

          result
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