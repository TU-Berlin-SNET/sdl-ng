require 'rspec'

shared_context 'the example HTML' do
  let :example_page do
    File.read(File.join(__dir__, 'shared_test_html.html'))
  end

  let :example_nokogiri_doc do
    Nokogiri::HTML(example_page)
  end
end