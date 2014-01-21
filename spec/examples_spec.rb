require_relative 'spec_helper'

require 'rspec'

describe 'the bundled examples' do
  let :compendium do
    SDL::Base::ServiceCompendium.new
  end

  let :loaded_compendium do
    expect {
      compendium.load_vocabulary_from_path File.join(__dir__, '..', 'examples', 'vocabulary')
      compendium.load_service_from_path File.join(__dir__, '..', 'examples', 'services')
    }.not_to raise_exception

    compendium
  end

  it 'can be loaded' do
    expect { loaded_compendium }.not_to raise_exception
  end

  it 'traces load path' do
    expected_path = File.join(__dir__, '..', 'examples', 'services', 'google_drive_for_business.service.rb')

    expect(loaded_compendium.services['google_drive_for_business'].loaded_from).to eq expected_path
  end
end