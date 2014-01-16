require 'rspec'

shared_context 'the example HTML' do
  let :example_page do
    <<END
<!DOCTYPE html>
<html>
  <head>
    <title>Example Page</title>
  </head>
  <body>
    <h1>Test Page</h1>
    <p>First test paragraph</p>
    <p>Second test paragraph: <a href="/test">Testlink</a></p>
  </body>
</html>
END
  end

  let :example_nokogiri_doc do
    Nokogiri::HTML(example_page)
  end
end