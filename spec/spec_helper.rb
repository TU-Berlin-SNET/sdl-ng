require 'simplecov'

require_relative '../lib/sdl'

Dir['lib/**/*.rb'].each do |file|
  require_relative File.join('..', file)
end

# spec_helper.rb
RSpec.configure do |config|
  # Disable 'should' for consistency
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end