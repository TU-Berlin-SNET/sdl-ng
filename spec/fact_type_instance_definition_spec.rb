# coding: utf-8

require_relative 'spec_helper'
require_relative 'shared_test_compendium'

require 'rspec'

shared_examples_for 'it can use identifiers for predefined types' do
  it 'can set facts' do
    eval "compendium.service :red_service do
      is_colored #{red_identifier}, 'Ruby Red'
    end"

    expect(compendium.services[:red_service].is_colored.color).to eq(SDL::Base::Type::Color[:red])
    expect(compendium.services[:red_service].is_colored.name).to eq("Ruby Red")
  end

  it 'lets service definitions use symbolic names also in lists' do
    eval "compendium.service :multicolored_service do
      multicolored #{red_identifier}
      multicolored #{green_identifier}
    end"

    expect(compendium.services[:multicolored_service].multicolored[0]).to eq(SDL::Base::Type::Color[:red])
    expect(compendium.services[:multicolored_service].multicolored[1]).to eq(SDL::Base::Type::Color[:green])
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
      multicolored do
        color :the_colour_of_magic
      end
    end}.to raise_exception

    expect do
      compendium.service :second_invalid_service do
        is_colored :the_colour_of_magic
      end
    end.to raise_exception

    expect {compendium.service :invalid_service do
      multicolored do
        color the_colour_of_magic
      end
    end}.to raise_exception

    expect do
      compendium.service :second_invalid_service do
        is_colored the_colour_of_magic
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

  it 'raises an error, if a value with an invalid type is given for multi valued properties' do
    expect {
      service = compendium.service(:invalid_service) do
        multicolored do
          color "Blue"
        end
      end
    }.to raise_exception
  end

  it 'can be done through multiple arguments and associative hashes' do
    compendium.instance_eval do
      type :multistring do
        string :a
        string :b
        string :c
        string :d
        string :e
      end
    end

    compendium.facts_definition do
      multistring :mstring

      list_of_multistrings :string_arrays
    end

    compendium.service :multi_service do
      mstring '1', '2', d: '3'

      string_array '1', '2', d: '3'
      string_array '3', '4', e: '5'
    end

    expect(compendium.services[:multi_service].mstring.a).to eq '1'
    expect(compendium.services[:multi_service].mstring.b).to eq '2'
    expect(compendium.services[:multi_service].mstring.c).to eq nil
    expect(compendium.services[:multi_service].mstring.d).to eq '3'
    expect(compendium.services[:multi_service].mstring.e).to eq(nil)

    expect(compendium.services[:multi_service].string_arrays[0].b).to eq '2'
    expect(compendium.services[:multi_service].string_arrays[1].e).to eq '5'
  end

  context 'the #to_s method of a fact' do
    it 'gives out the Fact class local name when no same-named property than the class exists' do
      compendium.service :blue_service do
        is_colored :blue
      end

      expect(compendium.services[:blue_service].is_colored.to_s).to eq 'SDL::Base::Type::ServiceColor'
    end
  end

  it 'lets facts be annotated by arbitrary values' do
    compendium.service :yellow_service do
      is_colored :yellow, annotation: "Yuck!"
    end

    expect(compendium.services[:yellow_service].is_colored.annotated?).to eq true
    expect(compendium.services[:yellow_service].is_colored.annotations).to include("Yuck!")
  end

  it 'lets fact have list types' do
    compendium.service :favourite_service do
      favourite_color :red, 5
      favourite_color :green, 10
    end

    expect(compendium.services[:favourite_service].favourite_colors[0].class.list_item?).to eq true

    expect(compendium.services[:favourite_service].favourite_colors[0].color).to eq(SDL::Base::Type::Color[:red])
    expect(compendium.services[:favourite_service].favourite_colors[1].color).to eq(SDL::Base::Type::Color[:green])
    expect(compendium.services[:favourite_service].favourite_colors[0].rating).to eq 5
    expect(compendium.services[:favourite_service].favourite_colors[1].rating).to eq 10
  end

  it 'returns the values of all properties by calling #property_values on a type' do
    service = compendium.service :imaginative_service do
      is_colored :yellow, 'Yellow'
    end

    property_values = service.property_values

    is_colored = SDL::Base::Type::Service.properties_hash[:is_colored]

    expect(property_values[is_colored].color).to eq(SDL::Base::Type::Color[:yellow])
    expect(property_values[is_colored].name).to eq 'Yellow'
  end

  it 'can reject empty property values if specifying include_empty' do
    property_values = compendium.service :empty_service do
      is_colored
    end.is_colored.property_values(false)

    expect(property_values).to be_empty
  end

  it 'returns its service for the parent of facts' do
    red_service = compendium.services[:red_service]

    expect(red_service.property_values.values.first.parent).to eq red_service
  end

  it 'returns a parent type or fact for the parent of types' do
    compendium.instance_eval do
      type :third_level_type

      type :second_level_type do
        third_level_type
      end

      type :first_level_type do
        second_level_type
      end

      third_level_type :third

      second_level_type :second do
        third_level_type :third
      end

      first_level_type :first do
        second_level_type :second
      end
    end

    compendium.facts_definition do
      first_level_type :first
    end

    service = compendium.service :service_with_children do
      first :first
    end

    first_level = service.first
    second_level = first_level.second_level_type
    third_level = second_level.third_level_type

    expect(third_level.parent).to eq second_level
    expect(second_level.parent).to eq first_level
  end

  it 'returns nil for #parent_index, if the type is used as value of a single-valued property' do
    new_color = SDL::Base::Type::Color.new

    compendium.service :service_single_value do
      is_colored new_color
    end

    expect(new_color.parent_index).to eq nil
  end

  it 'returns the index of a value in a multi-valued property when giving a compatible value for the list' do
    first_color = SDL::Base::Type::Color.new
    second_color = SDL::Base::Type::Color.new

    compendium.service :service_multi_value do
      multicolored first_color
      multicolored second_color
    end

    expect(Service[:service_multi_value].multicolored[0].parent_index).to eq 0
    expect(Service[:service_multi_value].multicolored[1].parent_index).to eq 1
  end

  it 'returns the index of a value in a multi-valued property when specifying a list value' do
    service = compendium.service :service_multi_value do
      favourite_color do
        color do
          hex_value '#123'
        end
      end

      favourite_color do
        color do
          hex_value '#456'
        end
      end
    end

    expect(service.favourite_colors[0].parent_index).to eq 0
    expect(service.favourite_colors[1].parent_index).to eq 1
  end

  it 'does not set #parent_index if given a predefined type' do
    service = compendium.service :service_multi_value_predefined_type do
      is_colored red
    end

    expect(SDL::Base::Type::Color.instances[:red].parent_index).to eq nil
  end

  it 'marks fact types with multiple properties as multi_property?' do
    SDL::Base::Type.subtypes_recursive.each do |type|
      if type.properties.count > 1
        expect(type.multi_property?).to eq true
      end
    end
  end

  it 'raises an error, if it gets the wrong type of property value' do
    expect {
      service = compendium.service :simple_service do
        name Object.new
      end
    }.to raise_exception
  end
end