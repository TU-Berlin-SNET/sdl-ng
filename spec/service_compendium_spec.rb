require_relative 'spec_helper'

require 'rspec'

describe 'The service compendium' do
  subject do
    SDL::Base::ServiceCompendium.new
  end

  before(:each) do
    subject.clear!
  end

  it 'allows the definition of service property' do
    expect(SDL::Base::Type::Service.propertyless?).to eq true

    subject.service_properties do
      string :my_property
    end

    expect(SDL::Base::Type::Service.propertyless?).to eq false
  end

  it 'allows the definition of service types' do
    subject.type :first_type

    expect(subject.types.first).to be < SDL::Base::Type
  end

  it 'allows the definition of service subtypes' do
    supertype = subject.type :supertype
    subtype = supertype.subtype :subtype

    expect(subject.types.first).to be > subject.types[1]
  end

  it 'allows the definition of services' do
    subject.service :example_service

    expect(subject.services[:example_service]).to be_a(SDL::Base::Type::Service)
    expect(subject.services[:example_service]).to eq(subject.services.first[1])
  end

  it 'can register defined classes globally' do
    subject.type :example_type

    subject.register_classes_globally

    expect(Kernel.const_get('ExampleType')).to be < SDL::Base::Type
  end

  it 'does not partially load invalid services' do
    compendium = SDL::Base::ServiceCompendium.new

    compendium.service_properties do
      string :first_string
      string :second_string
    end

    service_definition = <<END
first_string "ABC"
second_string "DEF"
third_string "GHI"
END

    expect{
      compendium.load_service_from_string(service_definition, 'my_service', 'empty')
    }.to raise_exception

    expect(compendium.services.size).to eq 0
  end

  it 'does not partially load invalid vocabulary' do
    new_compendium = SDL::Base::ServiceCompendium.new

    new_compendium.with_uri 'rspec' do
      new_compendium.type :first_type

      new_compendium.type_instances_definition do
        first_type :abc
      end
    end

    facts_definition = <<END
tüpe :third_type
END

    expect {
      new_compendium.load_vocabulary_from_string(facts_definition, 'empty')
    }.to raise_exception

    expect(new_compendium.types.count).to eq 1
    expect(new_compendium.type_instances.count).to eq 1
  end

  it 'allows to use properties in the definition of services' do
    subject.service_properties do
      complex_property do
        string :value
      end
    end
    subject.register_classes_globally

    subject.service :example_service do
      complex_property do
        value "ABC"
      end
    end

    expect(subject.services[:example_service].property_values.values.first).to be_a(ComplexProperty)
  end

  context 'with a new service type' do
    subject do
      compendium = SDL::Base::ServiceCompendium.new
      compendium.type :example_type
      compendium
    end

    it 'registers the code for the example type with its #all_codes' do
      expect(subject.all_codes[:example_type]).to be subject.types.first
    end
  end
end