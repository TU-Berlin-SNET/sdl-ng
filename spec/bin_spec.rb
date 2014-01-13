require_relative '../lib/sdl'
require_relative 'spec_helper'

require 'rspec'

describe 'The process_service_descriptions binary script' do
  it 'can be executed' do
    Dir.chdir(File.join(__dir__, '..', 'examples')) do
      `ruby #{File.join(__dir__, '..', 'bin', 'process_service_descriptions')}`

      expect($?.exitstatus).to eq(0)
    end
  end
end