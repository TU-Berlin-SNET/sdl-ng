require_relative 'spec_helper'

require 'rspec'

describe 'The process_service_descriptions binary script' do
  it 'can be executed' do
    Dir.chdir(File.join(__dir__, '..', 'examples')) do
      expect {
        load File.join(__dir__, '..', 'bin', 'process_service_descriptions')
      }.not_to raise_exception
    end
  end
end