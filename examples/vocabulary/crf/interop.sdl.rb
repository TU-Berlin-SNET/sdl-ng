type :browser do
  url
end

browser :firefox do
  url 'http://www.mozilla.org/firefox/'
end

browser :opera do
  url 'http://www.opera.com/'
end

browser :chrome do
  url 'https://www.google.com/chrome'
end

browser :internet_explorer do
  url 'http://windows.microsoft.com/en-US/internet-explorer/download-ie'
end

browser :safari do
  url 'http://www.apple.com/safari'
end

type :browser_plugin do
  url
end

browser_plugin :flash do
  url 'http://get.adobe.com/flashplayer'
end

browser_plugin :silverlight do
  url 'http://www.microsoft.com/silverlight'
end

type :interface do
  url :interface_documentation

  subtype :rest_interface
  subtype :soap_interface
  subtype :xmlrpc_interface

  subtype :browser_interface do
    list :compatible_browsers do
      browser
      string :min_version
    end

    list :required_plugins do
      browser_plugin
      string :min_version
    end
  end
end

service_properties do
  feature do
    string :feature_name
    description
  end

  url :documentation

  rest_interface
  soap_interface
  xmlrpc_interface
  browser_interface
end