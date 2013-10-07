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

has_data_capability 'export' do
  format :csv
  format :xls
end

is_billed :monthly

features = fetch_from_url 'http://www.salesforce.com/sales-cloud/overview/', '.slide h3 + p'

has_feature 'Mobile', features[0]
has_feature 'Contact Management', features[1]
has_feature 'Opportunity Management', features[2]
has_feature 'Chatter', features[3]
has_feature 'Email Integration', features[4]