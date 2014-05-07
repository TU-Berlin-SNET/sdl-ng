require_relative 'spec_helper'
require_relative 'shared_test_compendium'

require 'rspec'

store_translation = lambda {
  I18n.backend.store_translations('en', :sdl => {
      :type => {
          :color => 'A color',
          :color_supercolor => 'The service has a supercolor.'
      },
      :property => {
          :type => {
              :color => {
                  :hex_value => 'The hexadecimal color value.'
              }
          }
      },
      :instance => {
          :type => {
              :color => {
                  :red => 'The color "red"',
                  :blue => '#{hex_value}'
              }
          }
      }
  })
}

describe 'Documentation of SDL objects' do
  include_context 'the default compendium'

  # Registers the classes of the default compendium
  before(:each) do
    compendium.register_classes_globally

    store_translation.call
  end

  it 'can document types' do
    expect(Color.documentation).to eq('A color')
  end

  it 'can document subtypes' do
    expect(Supercolor.documentation).to eq('The service has a supercolor.')
  end

  it 'can document properties' do
    expect(Color.properties.first.documentation).to eq('The hexadecimal color value.')
  end

  it 'can document instances' do
    expect(Color[:red].documentation).to eq('The color "red"')
  end

  it 'adds missing translations to the I18n backend as "translate" string after trying to translate a missing key' do
    expect(Color[:green].documentation).to eq('translation missing: en.sdl.instance.type.color.green')

    expect(I18n.backend.instance_variable_get(:@translations)[:en][:sdl][:instance][:type][:color][:green]).to eq('Translate')
  end

  it 'evaluates statements enclosed within #{}' do
    expect(Color[:blue].documentation).to eq('#00F')
  end
end