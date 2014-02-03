require_relative 'spec_helper'

require 'rspec'

describe 'the bundled examples' do
  it 'can be (un-)loaded and traces the load path of files' do
    compendium = SDL::Base::ServiceCompendium.new

    expect {
      compendium.load_vocabulary_from_path File.join(__dir__, '..', 'examples', 'vocabulary')
      compendium.load_service_from_path File.join(__dir__, '..', 'examples', 'services')
    }.not_to raise_exception

    items_to_unload = []

    compendium.loaded_items do |loaded_item|
      expect(File.exists?(loaded_item.loaded_from))

      items_to_unload << loaded_item
    end

    items_to_unload.each do |loaded_item|
      expect{compendium.unload(loaded_item.loaded_from)}.not_to raise_exception
    end

    expect(compendium).to be_empty
  end
end