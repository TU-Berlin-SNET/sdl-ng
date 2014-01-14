require_relative '../lib/sdl'
require_relative 'spec_helper'
require_relative 'shared_test_compendium'

require 'rspec'

shared_examples_for 'a group of URI mapped objects' do
  it 'has valid URIs' do
    expect do
      subject.each do |object|
        uri = URI.parse object.uri

        expect(uri.host).to eq default_host
      end
    end.to_not raise_exception
  end
end

describe 'The mapping of URIs' do
  include_context 'the default compendium'

  let :default_host do
    'www.open-service-compendium.org'
  end

  context_resource_map = {
      'All services' => lambda { compendium.services.values },
      'All fact instances' => lambda { compendium.services.values.map(&:facts).flatten },
      'All fact classes' => lambda { compendium.fact_classes },
      'All type instances' => lambda { compendium.type_instances.values.map(&:values).flatten },
      'All type classes' => lambda { compendium.types }
  }

  context_resource_map.each do |context_name, to_test_lambda|
    context context_name do
      subject &to_test_lambda

      it_should_behave_like 'a group of URI mapped objects'
    end
  end

  context 'with an own URI mapper' do
    module CustomURIMapper
      def self.uri(object)
        'www.example.org'
      end
    end

    let :custom_host do
      'www.example.org'
    end

    let! :custom_mapped_resource do
      resource = Object.new

      resource.class_eval do
        include SDL::Base::URIMappedResource
      end

      resource
    end

    it 'should use class#@uri_mapper if provided' do
      resource = custom_mapped_resource

      resource.class.class_eval do
        @uri_mapper = CustomURIMapper
      end

      expect(resource.uri).to eq custom_host
    end

    it 'should use #uri_mapper if provided' do
      resource = custom_mapped_resource

      resource.class_eval do
        def uri_mapper
          CustomURIMapper
        end
      end

      expect(resource.uri).to eq custom_host
    end

    it 'should use class.uri_mapper if provided' do
      resource = custom_mapped_resource

      resource.class.class_eval do
        def self.uri_mapper
          CustomURIMapper
        end
      end

      expect(resource.uri).to eq custom_host
    end

    it 'should use @uri_mapper if provided' do
      resource = custom_mapped_resource

      resource.instance_variable_set :@uri_mapper, CustomURIMapper

      expect(resource.uri).to eq custom_host
    end
  end
end