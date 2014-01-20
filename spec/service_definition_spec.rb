require_relative 'spec_helper'

require 'rspec'

describe 'The definition of services' do
  let! :example_compendium do
    compendium = SDL::Base::ServiceCompendium.new

    compendium.facts_definition do
      fact :fact

      fact :my_value do
        string :my_value

        subfact :my_inherited_value
      end
    end

    compendium
  end

  context 'the addition of a Fact instance' do
    it 'allows the addition of a Fact instance using has_{Fact class name} syntax' do
      service = example_compendium.service(:example_service_1) do
        has_fact
      end

      expect(service.facts[0]).to be_a(example_compendium.fact_classes.first)
    end

    it 'allows the addition of a Fact instance using {Fact class name} syntax' do
      service = example_compendium.service(:example_service_2) do
        fact
      end

      expect(service.facts[0]).to be_a(example_compendium.fact_classes.first)
    end

    it 'allows the addition of a Fact instance using is_{Fact class name past participle} syntax' do
      service = example_compendium.service(:example_service_3) do
        is_facted
      end

      expect(service.facts[0]).to be_a(example_compendium.fact_classes.first)
    end
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

  it 'raises an error, if a value is given for a non-existing property' do
    expect do
      example_compendium.service(:example_service) do
        my_value "ABC", "DEF"
      end
    end.to raise_exception
  end

  it 'allows to access the first fact instance by its name' do
    service = example_compendium.service(:my_service) do
      my_value "ABC"
    end

    expect(service.my_value.my_value).to eq "ABC"
  end

  it 'allows to access all fact instances by their plural name' do
    service = example_compendium.service(:different_service) do
      my_value 'GHI'
      my_value 'JKL'
      my_value 'MNO'
    end

    expect(service.my_values.join).to eq 'GHIJKLMNO'
  end

  it 'lets facts be grouped by their fact class' do
    service = example_compendium.service(:another_service) do
      my_value 'ABC'
      my_value 'DEF'
    end

    fact_class_facts_map = service.fact_class_facts_map

    expect(fact_class_facts_map.keys[0]).to eq service.facts[0].class

    expect(fact_class_facts_map[service.facts[0].class][0]).to eq service.facts[0]
    expect(fact_class_facts_map[service.facts[0].class][1]).to eq service.facts[1]
  end
end