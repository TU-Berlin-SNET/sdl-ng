require_relative 'spec_helper'
require_relative 'shared_test_compendium'

require 'rspec'

shared_examples_for 'a group of URI mapped objects' do
  module CustomURIMapper
    def self.uri(object)
      'www.example.org'
    end
  end

  let :custom_host do
    'www.example.org'
  end

  it 'has valid URIs' do
    expect do
      subject.each do |object|
        uri = URI.parse object.uri

        expect(uri.host).to eq default_host
      end
    end.to_not raise_exception
  end

  context 'with an own URI mapper' do
    it 'should use class#@uri_mapper if provided' do
      subject.each do |resource|
        resource.class.class_eval do
          @uri_mapper = CustomURIMapper
        end

        expect(resource.uri).to eq custom_host

        resource.class.class_eval do
          @uri_mapper = nil
        end
      end
    end

    it 'should use #uri_mapper if provided' do
      subject.each do |resource|
        def resource.uri_mapper
          CustomURIMapper
        end

        expect(resource.uri).to eq custom_host

        resource.instance_eval do
          undef uri_mapper
        end
      end
    end

    it 'should use class.uri_mapper if provided' do
      subject.each do |resource|
        resource.class.class_eval do
          def self.uri_mapper
            CustomURIMapper
          end
        end

        expect(resource.uri).to eq custom_host

        resource.class.class_eval do
          class << self
            undef uri_mapper
          end
        end
      end
    end

    it 'should use @uri_mapper if provided' do
      subject.each do |resource|
        resource.instance_variable_set :@uri_mapper, CustomURIMapper

        expect(resource.uri).to eq custom_host

        resource.instance_variable_set :@uri_mapper, nil
      end
    end
  end
end

describe 'The mapping of URIs' do
  include_context 'the default compendium'

  let :default_host do
    'www.open-service-compendium.org'
  end

  context_resource_map = {
      'All services' => lambda { compendium.services.values },
      'All type instances' => lambda { Hash[SDL::Base::Type.instances_recursive.to_a].values },
      'All type classes' => lambda { compendium.types }
  }

  context_resource_map.each do |context_name, to_test_lambda|
    context context_name do
      subject &to_test_lambda

      it_should_behave_like 'a group of URI mapped objects'
    end
  end

  it 'should raise error for any other object' do
    resource = Object.new

    resource.class_eval do
      include SDL::Base::URIMappedResource
    end

    expect {
      resource.uri
    }.to raise_exception
  end
end