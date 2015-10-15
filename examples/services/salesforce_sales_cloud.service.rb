# base
service_name "Salesforce Sales Cloud"

# characteristics
cloud_service_model saas
add_on_repository do
  url 'https://appexchange.salesforce.com'
  number_of_add_ons 2000
end

# charging
is_charged_by user_account

# compliance
status_page 'http://trust.salesforce.com/trust/status'
public_service_level_agreement 'http://www.salesforce.com/assets/pdf/misc/salesforce_MSA.pdf'

# delivery
is_billed annually
is_charged in_advance
payment_option credit_card
payment_option cheque
payment_option invoice

# dynamics

# interop
documentation 'http://www.salesforce.com/sales-cloud/overview'
rest_interface
soap_interface
xmlrpc_interface

compatible_browser internet_explorer, '7'
compatible_browser firefox
compatible_browser chrome
compatible_browser safari, '5', annotation: 'on Mac'

dynamic do
  feature_headers = fetch_from_url 'http://www.salesforce.com/sales-cloud/features/', 'h3'

  feature_headers.to_a[1..-1].each do |feature_header|
    feature feature_header.content.strip, feature_header.search('~p')[0]
  end
end

# optimizing
maintenance_free
future_roadmap 'http://www.sfdcstatic.com/assets/pdf/misc/summer13_ReleasePreview.pdf'
past_release_notes 'http://www.salesforce.com/newfeatures'

# portability
exportable_data_format csv

# protection
is_protected_by https

# reliability
can_be_used_offline yes, annotation: 'http://help.salesforce.com/apex/HTViewHelpDoc?id=offline_def.htm'

# reputation
established_in 1999

# trust
provider do
  provider_name "Salesforce.com"
  company_type plc
  employs 12000
  partner_network 'http://www.salesforce.com/partners/overview/'
  last_years_revenue '4070000000 $'
  report financial_statement, quarterly

  reference_customer 'Philips' do
    url 'http://www.salesforce.com/customers/stories/philips.jsp'
    users 7000
  end
end