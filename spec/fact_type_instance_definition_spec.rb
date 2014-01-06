require_relative '../lib/sdl'
require_relative 'spec_helper'
require_relative 'shared_test_compendium'

require 'rspec'

shared_examples_for 'it can use identifiers for predefined types' do
  it 'can set facts' do
    eval "compendium.service :red_service do
      has_color #{red_identifier}, 'Ruby Red'
    end"

    expect(compendium.services[:red_service].facts[0].color).to eq(compendium.type_instances[Color][:red])
    expect(compendium.services[:red_service].facts[0].name).to eq("Ruby Red")
  end

  it 'lets service definitions use symbolic names also in lists' do
    eval "compendium.service :multicolored_service do
      has_multicolor do
        color #{red_identifier}
        color #{green_identifier}
      end
    end"

    expect(compendium.services[:multicolored_service].facts[0].colors[0]).to eq(compendium.type_instances[Color][:red])
    expect(compendium.services[:multicolored_service].facts[0].colors[1]).to eq(compendium.type_instances[Color][:green])
  end
end

describe 'Doing type instance definition' do
  include_context 'the default compendium'

  # Registers the classes of the default compendium
  before(:each) do
    compendium.register_classes_globally
  end

  context 'With identifiers as symbolic names' do
    it_should_behave_like 'it can use identifiers for predefined types' do
      let :red_identifier do
        ':red'
      end

      let :green_identifier do
        ':green'
      end
    end
  end

  context 'With identifiers as regular names (i.e. method calls)' do
    it_should_behave_like 'it can use identifiers for predefined types' do
      let :red_identifier do
        'red'
      end

      let :green_identifier do
        'green'
      end
    end
  end

  it 'raises errors if it detects non existing names or symbols' do
    expect {compendium.service :invalid_service do
      has_multicolor do
        color :the_colour_of_magic
      end
    end}.to raise_exception

    expect do
      compendium.service :second_invalid_service do
        has_color :the_colour_of_magic
      end
    end.to raise_exception

    expect {compendium.service :invalid_service do
      has_multicolor do
        color the_colour_of_magic
      end
    end}.to raise_exception

    expect do
      compendium.service :second_invalid_service do
        has_color the_colour_of_magic
      end
    end.to raise_exception
  end

  it 'raises an error, if multiple predefined type instances with the same name are found by #method_missing' do
    expect do
      compendium.service :service_with_ambiguous_reference do
        color text
      end
    end.to raise_exception
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

    expect(compendium.services[:multi_service].facts[0].a).to eq '1'
    expect(compendium.services[:multi_service].facts[0].b).to eq '2'
    expect(compendium.services[:multi_service].facts[0].c).to eq nil
    expect(compendium.services[:multi_service].facts[0].d).to eq '3'
    expect(compendium.services[:multi_service].facts[0].e).to eq(nil)

    expect(compendium.services[:multi_service].facts[1].multis[0].b).to eq '2'
    expect(compendium.services[:multi_service].facts[1].multis[1].e).to eq '5'
  end

  context 'the #to_s method of a fact' do
    it 'gives out the #to_s output of a same-named property than the class' do
      compendium.service :named_service do
        has_name 'My name'
      end

      expect(compendium.services[:named_service].facts[0].to_s).to eq 'My name'
    end

    it 'gives out the Fact class local name when no same-named property than the class exists' do
      compendium.service :blue_service do
        has_color :blue
      end

      expect(compendium.services[:blue_service].facts[0].to_s).to eq 'Color'
    end
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
    expect(compendium.services[:favourite_service].facts[0].favourites[0].rating).to eq 5
    expect(compendium.services[:favourite_service].facts[0].favourites[1].rating).to eq 10
  end

  it 'returns the values of all properties by calling #property_values on a type' do
    compendium.service :imaginative_service do
      has_color :yellow, 'Yellow'
    end

    property_values = compendium.services[:imaginative_service].facts[0].property_values

    expect(property_values[property_values.keys[0]]).to eq(compendium.type_instances[Color][:yellow])
    expect(property_values[property_values.keys[1]]).to eq 'Yellow'
  end
end