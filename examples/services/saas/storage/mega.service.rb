# base
service_name 'Mega'

service_category storage

# characteristics
cloud_service_model saas
#add_on_repository 'https://www.google.com/enterprise/marketplace/home', 1000

# charging
is_charged_by user_account

# compliance
#status_page ''
public_service_level_agreement 'https://mega.co.nz/#terms'

# delivery
is_billed monthly
is_charged in_advance
payment_option credit_card

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
documentation 'https://mega.co.nz/#doc'
rest_interface 'https://mega.co.nz/#doc'

compatible_browser firefox, 'recent'
compatible_browser chrome, 'recent'
compatible_browser safari, 'recent'
compatible_browser internet_explorer, 'recent'

# optimizing
maintenance_free
#past_release_notes 'https://plus.google.com/+GoogleDrive/posts'
#feedback_page 'https://plus.google.com/+GoogleDrive/posts'

# protection
is_protected_by https

# reliability
can_be_used_offline no

# reputation
established_in 2013

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

two_factor_auth no
sso no


file_locking no
permission_revocation no
granular_permission no


#monitoring yes

data_encryption user_only, directory_based, aes
transmission_encryption 'TLS'


#deduplication_type
#replication yes
#delta_encoding no

#location :data_location

#max_file_size " TB"
max_storage_capacity "4 TB"

#version_control no
#compression yes


#availability "%"
#reliability "%"


sharing public_link
#sharing collaboration

multi_tenancy no

compatible_operating_system windows, 'recent'
compatible_operating_system mac_osx, 'recent'
compatible_operating_system linux, 'recent'

mobile_device android
mobile_device blackberry
mobile_device iphone
mobile_device ipad
mobile_device windows_phone

