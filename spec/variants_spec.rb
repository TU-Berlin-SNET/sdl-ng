require_relative 'spec_helper'
require_relative 'shared_test_compendium'

require 'rspec'

describe 'Services having variants' do
  include_context 'the default compendium'

  # Registers the classes of the default compendium
  before(:each) do
    compendium.register_classes_globally
  end

  it 'can be defined' do
    compendium.service :one_variant do
      name "My Service"
    end
  end
end