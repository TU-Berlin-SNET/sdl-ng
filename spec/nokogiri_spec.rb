require_relative 'spec_helper'

require 'rspec'

describe 'The nokogiri helper' do
  # Mocks also open()
  let :nokogiri_utils do
    util_object = Object.new

    util_object.class_eval do
      include SDL::Util::NokogiriUtils

      def open(url)
        if(url.eql? 'http://www.shared-test-html.html/test')
          Kernel.open(File.join(__dir__, 'shared_test_html.html'))
        else
          raise SocketError.new
        end
      end
    end

    util_object
  end

  let :html_root do
    nokogiri_utils.fetch_from_url 'http://www.shared-test-html.html/test', 'html'
  end

  let :first_link do
    html_root.search('a[@href]')[0]
  end

  it 'can open and process html content' do
    expect {
      html_root
    }.to_not raise_exception
  end

  it 'can rewrite relative to absolute links' do
    expect(first_link[:href]).to eq 'http://www.shared-test-html.html/test'
  end

  it 'can rewrite link targets' do
    expect(first_link[:target]).to eq '_new'
  end

  it 'silently ignores invalid link urls' do
    expect(html_root.search('a[@href]')[1][:href]).to eq '::#::'
  end

  it 'returns an empty array if getting an SocketError' do
    expect(nokogiri_utils.fetch_from_url('http://SocketError', 'html')).to eq []
  end
end