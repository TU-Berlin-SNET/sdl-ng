name "Salesfoce Sales Cloud"

service_function 'Mobile'
service_function 'Contact Management'
service_function 'Opportunity Management'
service_function 'Chatter'
service_function 'Email Integration'

has_rest_interface
has_soap_interface
has_xmlrpc_interface

has_browser_interface do
  compatible_browser :firefox do
    min_version "1"
  end

  compatible_browser :chrome do
    min_version "2"
  end

  compatible_browser :opera do
    min_version "3"
  end
end