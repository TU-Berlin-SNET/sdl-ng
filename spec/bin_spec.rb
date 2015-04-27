require_relative 'spec_helper'

require 'rspec'

describe 'The process_service_descriptions binary script' do
  it 'can be executed' do
    Dir.chdir(File.join(__dir__, '..', 'examples')) do
      old_argv = ARGV
      ARGV = []

      old_argf = ARGF
      ARGF = ''

      expect {
        load File.join(__dir__, '..', 'bin', 'process_service_descriptions')
      }.not_to raise_exception

      ARGV = old_argv
      ARGF = old_argf
    end
  end
end