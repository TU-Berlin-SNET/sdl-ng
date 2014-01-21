SimpleCov.start do
  # any custom configs like groups and filters can be here at a central place
  add_group 'Library', 'lib'
  add_group 'Specs', 'spec'

  add_filter 'bin'
  add_filter 'examples'

  refuse_coverage_drop
end