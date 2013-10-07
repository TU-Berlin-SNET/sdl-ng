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

      fact :multicolor do
        list_of_colors :colors
      end

      fact :favourite_colors do
        list :favourites do
          color :color
          int :rating
        end
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

  it 'lets service definitions use symbolic names also in lists' do
    compendium.service :multicolored_service do
      has_multicolor do
        color :red
        color :green
      end
    end

    expect(compendium.services[:multicolored_service].facts[0].colors[0]).to eq(compendium.type_instances[Color][:red])
    expect(compendium.services[:multicolored_service].facts[0].colors[1]).to eq(compendium.type_instances[Color][:green])
  end

  it 'raises errors if it detects non existing symbolic names' do
    expect {compendium.service :invalid_service do
      has_multicolor do
        color :the_colour_of_magic
      end
    end}.to raise_exception
  end

  it 'can be done through multiple arguments and associative hashes' do
    compendium.facts_definition do
      type :multi do
        string :a
        string :b
        string :c
        string :d
        string :e
      end

      fact :multi do
        string :a
        string :b
        string :c
        string :d
        string :e
      end

      fact :multi_multi do
        list_of_multis :multis
      end
    end

    compendium.service :multi_service do
      multi '1', '2', d: '3'

      multi_multi do
        multi '1', '2', d: '3'
        multi '3', '4', e: '5'
      end
    end

    expect(compendium.services[:multi_service].facts[0].a).to eql '1'
    expect(compendium.services[:multi_service].facts[0].b).to eql '2'
    expect(compendium.services[:multi_service].facts[0].c).to eq(nil)
    expect(compendium.services[:multi_service].facts[0].d).to eql '3'
    expect(compendium.services[:multi_service].facts[0].e).to eq(nil)

    expect(compendium.services[:multi_service].facts[1].multis[0].b).to eql '2'
    expect(compendium.services[:multi_service].facts[1].multis[1].e).to eql '5'
  end

  it 'gives out the Fact class local name when #to_s is called' do
    compendium.service :blue_service do
      has_color :blue
    end

    expect(compendium.services[:blue_service].facts[0].to_s).to eq('Color')
  end

  it 'lets facts be annotated by arbitrary values' do
    compendium.service :yellow_service do
      has_color :yellow, annotation: "Yuck!"
    end

    expect(compendium.services[:yellow_service].facts[0].annotations).to include("Yuck!")
  end

  it 'lets fact have list types' do
    compendium.service :favourite_service do
      favourite_colors do
        favourite :red, 5
        favourite :green, 10
      end
    end

    expect(compendium.services[:favourite_service].facts[0].favourites[0].color).to eq(compendium.type_instances[Color][:red])
    expect(compendium.services[:favourite_service].facts[0].favourites[1].color).to eq(compendium.type_instances[Color][:green])
    expect(compendium.services[:favourite_service].facts[0].favourites[0].rating).to eq(5)
    expect(compendium.services[:favourite_service].facts[0].favourites[1].rating).to eq(10)
  end
end