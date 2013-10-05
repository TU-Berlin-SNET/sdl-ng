name "Salesfoce Sales Cloud"

has_documentation 'Overview', url: 'http://www.salesforce.com/sales-cloud/overview/'

has_rest_interface
has_soap_interface
has_xmlrpc_interface

has_browser_interface do
  compatible_browser :internet_explorer, '7'
  compatible_browser :firefox, 'recent'
  compatible_browser :chrome, 'recent'
  compatible_browser :safari, '5', annotation: 'on Mac'
end

features = fetch_from_url 'http://www.salesforce.com/sales-cloud/overview/', '.slide h3 + p'

feature 'Mobile', features[0]
feature 'Contact Management', features[1]
feature 'Opportunity Management', features[2]
feature 'Chatter', features[3]
feature 'Email Integration', features[4]