type :browser do
  url
end

type :browser_plugin do
  url
end

fact :feature do
  string :feature
  description
end

fact :documentation do
  url
end

fact :interface do
  subfact :rest_interface
  subfact :soap_interface
  subfact :xmlrpc_interface

  subfact :browser_interface do
    list :compatible_browsers do
      browser :compatible_browser
      string :min_version
    end

    list :required_plugins do
      browser_plugin :required_plugin
      string :min_version
    end
  end
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