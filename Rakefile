require 'bundler/gem_tasks'

gem 'yard'
gem 'redcarpet'
gem 'github-markup'

YARD::Rake::YardocTask.new do |yardoc|
  yardoc.files = ['lib/**/*.rb', '-', 'README.md']
  yardoc.options << '--title' << 'Service Description Language Framework Documentation'
  yardoc.options << '--markup-provider' << 'redcarpet'
  yardoc.options << '--markup' << 'markdown'
end