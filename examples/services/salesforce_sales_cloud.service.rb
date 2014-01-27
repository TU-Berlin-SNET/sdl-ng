name "Salesforce Sales Cloud"

has_documentation url: 'http://www.salesforce.com/sales-cloud/overview'

has_add_on_repository do
  url 'https://appexchange.salesforce.com'
  number_of_add_ons 2000
end

has_communication_protection https

has_status_page 'http://trust.salesforce.com/trust/status'

has_public_service_level_agreement 'http://www.salesforce.com/assets/pdf/misc/salesforce_MSA.pdf'

has_establishing_year 1999

has_offline_capability annotation: 'http://help.salesforce.com/apex/HTViewHelpDoc?id=offline_def.htm'

maintenance_free

has_future_roadmap 'http://www.sfdcstatic.com/assets/pdf/misc/summer13_ReleasePreview.pdf'
has_past_release_notes 'http://www.salesforce.com/newfeatures'

has_cloud_service_model saas

has_rest_interface
has_soap_interface
has_xmlrpc_interface

has_browser_interface do
  compatible_browser internet_explorer, '7'
  compatible_browser firefox, 'recent'
  compatible_browser chrome, 'recent'
  compatible_browser safari, '5', annotation: 'on Mac'
end

has_export_capability csv

is_billed annually, in_advance

has_payment_option credit_card
has_payment_option cheque
has_payment_option invoice

features = fetch_from_url 'http://www.salesforce.com/sales-cloud/overview', '.slide h3 + *'

has_feature 'Mobile', features[0]
has_feature 'Contact Management', features[1]
has_feature 'Opportunity Management', features[2]
has_feature 'Chatter', features[3]
has_feature 'Email Integration', features[4]