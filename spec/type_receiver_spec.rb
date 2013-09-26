require_relative '../lib/sdl'
require_relative 'spec_helper'

require 'rspec'

describe 'The type receiver' do
  context 'when initialized with :my_example_type' do
    subject do
      SDL::Receivers::TypeReceiver.new(:my_example_type)
    end

    it 'registers its types as an SDL type with code :my_example_type' do
      defined_type_class = subject.type_class
      registered_sdl_type = SDL::Types.registry[:my_example_type]

      expect(registered_sdl_type).to be(defined_type_class)
      expect(defined_type_class).to be < SDL::Base::Type
    end
  end
end