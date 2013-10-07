require_relative '../lib/sdl'
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