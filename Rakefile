gem 'yard'
gem 'redcarpet'
gem 'yard-redcarpet-ext'

require 'bundler/gem_tasks'

require 'yard'
require 'redcarpet'
require 'yard-redcarpet-ext'

YARD::Rake::YardocTask.new do |yardoc|
  yardoc.files = ['lib/**/*.rb', '-', 'README.md']
  yardoc.options << '--title' << 'Service Description Language Framework Documentation'
  yardoc.options << '--plugin' << 'redcarpet-ext'
  yardoc.options << '-M' << 'redcarpet'
end