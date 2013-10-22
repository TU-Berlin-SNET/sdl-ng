require_relative '../lib/sdl'
require_relative 'spec_helper'
require_relative 'shared_test_compendium'

require 'rspec'

describe 'Documentation of SDL objects' do
  include_context 'the default compendium'

  I18n.backend.store_translations('en', :sdl => {
      :type => {
          :color => 'A color'
      },
      :fact => {
          :multicolor => 'The service is multi-colored.',
          :favourite_colors => {
              :favourites => 'The favourite colors'
          }
      }
  })

  # Registers the classes of the default compendium
  before(:each) do
    compendium.register_classes_globally
  end

  it 'can document types' do
    expect(Color.documentation).to eq('A color')
  end

  it 'can document facts' do
    expect(Multicolor.documentation).to eq('The service is multi-colored.')
  end

  it 'can document properties' do
    expect(FavouriteColors.properties.first.documentation).to eq('The favourite colors')
  end
end