require_relative 'spec_helper'

require 'rspec'

describe 'The service compendium' do
  subject do
    SDL::Base::ServiceCompendium.new
  end

  it 'has empty arrays' do
    %w[fact_classes types type_instances services].each do |list|
      expect(subject.send(list)).to be_empty
    end
  end

  it 'allows the definition of service fact classes' do
    subject.fact :has_example_fact

    expect(subject.fact_classes.first).to be < SDL::Base::Fact
    expect(subject.fact_classes.first.propertyless?).to eq true
  end

  it 'allows the definition of fact subclasses' do
    subject.fact :example_fact do
      subfact :example_subfact
    end

    expect(subject.fact_classes.last.superclass).to be subject.fact_classes.first
  end

  it 'allows the definition of service types' do
    subject.type :example_type

    expect(subject.types.first).to be < SDL::Base::Type
  end

  it 'allows the definition of services' do
    subject.service :example_service

    expect(subject.services[:example_service]).to be_a(SDL::Base::Service)
    expect(subject.services[:example_service]).to eq(subject.services.first[1])
  end

  it 'can register defined classes globally' do
    subject.fact :example_fact
    subject.type :example_type

    subject.register_classes_globally

    expect(Kernel.const_get('ExampleFact')).to be < SDL::Base::Fact
    expect(Kernel.const_get('ExampleType')).to be < SDL::Base::Type
  end

  it 'has a #facts_definition shortcut' do
    subject.facts_definition do
      CONTEXT_SELF = self
    end

    expect(subject).to be CONTEXT_SELF
  end

  it 'is independent of one another' do
    first_compendium = SDL::Base::ServiceCompendium.new
    second_compendium = SDL::Base::ServiceCompendium.new

    first_compendium.facts_definition do
      fact :first
    end

    second_compendium.facts_definition do
      fact :second
    end

    expect {
      first_compendium.service 'first_service' do
        has_second
      end
    }.to raise_exception

    service = first_compendium.service 'second_service' do
      has_first
    end

    expect(service).not_to respond_to :second
  end

  it 'does not partially load invalid services' do
    compendium = SDL::Base::ServiceCompendium.new

    compendium.facts_definition do
      fact :first_fact
      fact :second_fact
    end

    service_definition = <<END
has_first_fact
has_second_fact
has_third_fact
END

    expect{
      compendium.load_service_from_string(service_definition, 'my_service', 'empty')
    }.to raise_exception

    expect(compendium.services.size).to eq 0
  end

  it 'does not partially load invalid vocabulary' do
    new_compendium = SDL::Base::ServiceCompendium.new

    new_compendium.with_uri 'rspec' do
      new_compendium.type_instances_definition do
        fact :first_fact
        type :first_type

        first_type :abc
      end
    end

    facts_definition = <<END
fact :second_fact
type :second_type

second_type :def

fakt :third_fact
tüpe :third_type
END

    expect {
      new_compendium.load_vocabulary_from_string(facts_definition, 'empty')
    }.to raise_exception

    expect(new_compendium.fact_classes.count).to eq 1
    expect(new_compendium.types.count).to eq 1
    expect(new_compendium.type_instances.count).to eq 1
  end

  it 'does not let double definitions of types and facts happen' do
    pending 'Not yet implemented'
  end

  context 'with defined example classes' do
    subject do
      compendium = SDL::Base::ServiceCompendium.new
      compendium.fact :example_fact
      compendium.register_classes_globally
      compendium
    end

    it 'allows to use these facts in the definition of services' do
      subject.service :example_service do
        has_example_fact
      end

      expect(subject.services[:example_service].facts.first).to be_an(ExampleFact)
    end
  end

  context 'with a new service type' do
    subject do
      compendium = SDL::Base::ServiceCompendium.new
      compendium.type :example_type
      compendium
    end

    it 'registers the code for the example type with its #sdltype_codes' do
      expect(subject.sdltype_codes[:example_type]).to be subject.types.first
    end
  end
end