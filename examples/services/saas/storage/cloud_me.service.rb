# base
service_name 'Cloud Me'

service_category storage

# characteristics
cloud_service_model saas
#add_on_repository 'https://www.google.com/enterprise/marketplace/home', 1000

# charging
is_charged_by user_account

# compliance
#status_page ''
public_service_level_agreement ''

# delivery
is_billed monthly
is_charged in_advance
payment_option credit_card
payment_option paypal

# dynamics
#dynamic do
# Fetch a list of features from the Google Apps page
#  fetch_from_url('https://www.google.com/work/apps/business/products/drive/', 'div.maia-col-6.text div.vcenter h2').each do |header|
# Skip empty features (e.g. "more information...")
#    next if header.search('~p')[0].blank?

# Extract Google Apps Features
#feature header.content.strip, header.search('~p')[0]
#  end
#end

# interop
#documentation 'https://www.google.com/enterprise/apps/business/products.html#drive'
rest_interface 'https://www.cloudme.com/api_src/CloudMe%20API%201.0.3.pdf'
soap_interface 'https://www.cloudme.com/api_src/CloudMe%20API%201.0.3.pdf'


compatible_browser firefox, 'recent', annotation: 'simple interface'
compatible_browser chrome, 'recent', annotation: 'simple interface'
compatible_browser safari, 'recent', annotation: 'simple interface'
compatible_browser internet_explorer, '7+'

# optimizing
#maintenance_free
#past_release_notes 'https://plus.google.com/+GoogleDrive/posts'
#feedback_page 'https://plus.google.com/+GoogleDrive/posts'

# protection
#is_protected_by https

# reliability
can_be_used_offline yes, annotation: ''

# reputation
established_in 2011

# trust
# provider do
#   company_type plc
#   employs 49829
#   partner_network 'https://www.google.com/intx/de/work/apps/business/driveforwork/partner-logos'
#   last_years_revenue '59820000000 $'
#   report financial_statement, quarterly
#
#   reference_customer 'The Weather Company'
#   reference_customer 'Kaplan'
#   reference_customer 'HP'
#   reference_customer 'Jaguar'
#   reference_customer 'Land Rover'
# end

# trust
provider do
  provider_name 'CloudMe AB'

  headquarters do
    name 'CloudMe AB'
    country_code 'SE'
    street_address 'Drottninggatan 23'
    locality 'Linköping'
  end

end

datacenter do
  country_code 'SE'
end

two_factor_auth no
sso no


file_locking no
permission_revocation no
granular_permission no


#audit_option audit_log

monitoring no

#transmission_encryption tlsv1_2


#deduplication_type
replication no
delta_encoding no

#location sweden

max_file_size "2 GB"
max_storage_capacity "5TB"

version_control no
compression no


#availability "%"
#reliability "%"


sharing public_link
sharing collaboration

multi_tenancy no

compatible_operating_system windows, 'recent'
compatible_operating_system mac_osx, 'recent'
compatible_operating_system linux, 'recent'

interface java

mobile_device android
mobile_device iphone
mobile_device ipad

