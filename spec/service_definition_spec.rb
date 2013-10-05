require_relative '../lib/sdl'
require_relative 'spec_helper'

require 'rspec'

describe 'The definition of services' do
  let! :example_compendium do
    compendium = SDL::Base::ServiceCompendium.new

    compendium.facts_definition do
      fact :simple_fact

      fact :my_value do
        string :my_value

        subfact :my_inherited_value
      end
    end

    compendium
  end

  it 'allows the addition of a Fact instance using has_{Fact class name} syntax' do
    example_compendium.service(:example_service) do
      has_simple_fact
    end

    example_service = example_compendium.services[:example_service]
    example_fact_instance = example_service.facts.first

    expect(example_fact_instance).to be_a(example_compendium.fact_classes.first)
  end

  it 'allows the addition of a Fact instance using {Fact class name} syntax' do
    example_compendium.service(:example_service) do
      simple_fact
    end

    example_service = example_compendium.services[:example_service]
    example_fact_instance = example_service.facts.first

    expect(example_fact_instance).to be_a(example_compendium.fact_classes.first)
  end

  it 'allows to set a property value of a Fact instance, when both the property and the instance class have the same name' do
    compendium = example_compendium

    compendium.service(:example_service) do
      my_value "ABC"
      my_inherited_value "BCD"
    end

    example_service = compendium.services[:example_service]
    my_inherited_value_fact = example_service.facts.last

    expect(my_inherited_value_fact).to be_a(compendium.fact_classes.last)

    expect(my_inherited_value_fact.my_value).to eq("BCD")
  end
end