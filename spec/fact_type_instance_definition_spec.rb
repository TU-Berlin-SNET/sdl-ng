require_relative '../lib/sdl'
require_relative 'spec_helper'

require 'rspec'

describe 'The definition of type instances' do
  let :compendium do
    compendium = SDL::Base::ServiceCompendium.new

    compendium.facts_definition do
      type :color do
        string :hex_value
      end

      fact :color do
        color :color
        string :name
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
    compendium.service :red_service do
      has_color :red, "Ruby Red"
    end

    expect(compendium.services[:red_service].facts[0].color).to eq(compendium.type_instances[Color][:red])
    expect(compendium.services[:red_service].facts[0].name).to eq("Ruby Red")
  end

  it 'can be done through multiple arguments and associative hashes' do
    compendium.facts_definition do
      fact :triple do
        string :a
        string :b
        string :c
        string :d
        string :e
      end
    end

    compendium.service :triple_service do
      triple '1', '2', d: '3'
    end

    expect(compendium.services[:triple_service].facts[0].a).to eql '1'
    expect(compendium.services[:triple_service].facts[0].b).to eql '2'
    expect(compendium.services[:triple_service].facts[0].c).to eq(nil)
    expect(compendium.services[:triple_service].facts[0].d).to eql '3'
    expect(compendium.services[:triple_service].facts[0].e).to eq(nil)
  end
end