require_relative '../lib/sdl'
require_relative 'spec_helper'

require 'rspec'

describe 'A service fact' do
  it 'has custom Class#to_s and #to_s method, which gives out the local name of the class' do
    class NewFact
      @local_name = "NewFact"
    end

    expect(NewFact.to_s).to eq("NewFact")
    expect(NewFact.new.to_s).to match(/#<NewFact:0x.*>/)
  end
end