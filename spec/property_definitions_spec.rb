require_relative '../lib/sdl'
require_relative 'spec_helper'

require 'rspec'

describe 'The definition of properties' do
  subject do
    SDL::Receivers::TypeReceiver.new :my_example_type
  end

  it 'allows the definition of properties' do
    subject.string :my_string_property

    defined_property = subject.type_class.properties.first

    expect(defined_property.name).to eq "my_string_property"
    expect(defined_property.type).to be SDL::Types::SDLString
    expect(defined_property.multi).to be_false
  end

  it 'allows the definition of list properties' do
    subject.list_of_integers :my_integer_list

    defined_property = subject.type_class.properties.first

    expect(defined_property.name).to eq("my_integer_list")
    expect(defined_property.type).to be SDL::Types::SDLNumber
    expect(defined_property.multi).to be_true
  end

  it 'does not handle unknown types' do
    expect {subject.unknown_type}.to raise_exception
  end
end