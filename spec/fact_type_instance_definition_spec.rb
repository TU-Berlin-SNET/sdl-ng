require_relative '../lib/sdl'
require_relative 'spec_helper'

require 'rspec'

describe 'The definition of type instances' do
  let! :example_compendium do
    compendium = SDL::Base::ServiceCompendium.new

    compendium.facts_definition do
      type :color do
        string :hex_value
      end

      fact :color do
        color :color
      end
    end

    compendium.type_instances_definition do
      color :red do
        hex_value '#F00'
      end

      color :green do
        hex_value '#0F0'
      end
    end

    compendium.register_classes_globally

    compendium
  end

  it 'lets service definitions use predefined type instances by their symbolic name' do
    compendium = example_compendium

    compendium.service :red_service do
      has_color :red
    end

    expect(compendium.services[0].facts[0].color).to eq(compendium.type_instances[Color][:red])
  end
end