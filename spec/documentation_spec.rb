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
          :color_supercolor => 'The service has a supercolor.'
      },
      :property => {
          :fact => {
              :favourite_colors => {
                  :favourites => 'The favourite colors'
              }
          }
      },
      :instance => {
          :type => {
              :color => {
                  :red => 'The color "red"'
              }
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

  it 'can document subfacts' do
    expect(Supercolor.documentation).to eq('The service has a supercolor.')
  end

  it 'can document properties' do
    expect(FavouriteColors.properties.first.documentation).to eq('The favourite colors')
  end

  it 'can document instances' do
    expect(compendium.type_instances[Color][:red].documentation).to eq('The color "red"')
  end

  it 'adds missing translations to the I18n backend as "translate" string after trying to translate a missing key' do
    expect(compendium.type_instances[Color][:green].documentation).to eq('translation missing: en.sdl.instance.type.color.green')

    expect(I18n.backend.instance_variable_get(:@translations)[:en][:sdl][:instance][:type][:color][:green]).to eq('Translate')
  end
end