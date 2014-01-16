require_relative 'spec_helper'
require_relative 'shared_test_html'

require 'rspec'

describe 'The simple types' do
  include_context 'the example HTML'

  context 'The SDLDescription type' do
    it 'is empty if created from nil' do
      type = SDL::Types::SDLDescription.new nil

      expect(type).to eq ''
      expect(type.to_html).to eq ''
    end

    it 'contains squished content from Nokogiri XML Element' do
      expect(SDL::Types::SDLDescription.new(example_nokogiri_doc.search('p')[0])).to eq 'First test paragraph'
    end

    it 'has a method #to_html, which returns HTML when created from Nokogiri XML Element' do
      expect(SDL::Types::SDLDescription.new(example_nokogiri_doc.search('p')[0]).to_html).to eq '<p>First test paragraph</p>'
    end

    it 'contains a string and returns it by #to_html' do
      expect(SDL::Types::SDLDescription.new('ABC').to_html).to eq 'ABC'
    end

    it 'raises an error, if #to_html is called with an unsupported object type' do
      description = SDL::Types::SDLDescription.new ('ABC')

      description.instance_eval do
        @raw_value = Object.new
      end

      expect {
        description.to_html
      }.to raise_exception
    end
  end

  context 'The SDLUrl type' do
    it 'parses correct URLs' do
      type_instance = SDL::Types::SDLUrl.new('http://www.open-service-compendium.org')

      expect(type_instance.value.host).to eq 'www.open-service-compendium.org'
    end

    it 'raises an error with invalid URLs' do
      expect {
        SDL::Types::SDLUrl.new('://')
      }.to raise_exception
    end
  end
end