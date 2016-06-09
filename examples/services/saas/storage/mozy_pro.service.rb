# base
service_name 'MozyPro'

service_category storage

# characteristics
cloud_service_model saas
#add_on_repository 'https://www.google.com/enterprise/marketplace/home', 1000

# charging
is_charged_by user_account

# compliance
#status_page ''
public_service_level_agreement 'https://mozy.com/about/legal/terms'

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
documentation 'http://support.mozy.com/Documentation'
rest_interface 'http://support.mozy.com/articles/en_US/Documentation/admin-api-whitelist-a'

compatible_browser firefox, 'recent'
compatible_browser chrome, 'recent'
compatible_browser safari, 'recent'
compatible_browser internet_explorer, 'recent'

# optimizing
maintenance_free
past_release_notes 'http://support.mozy.de/articles/de/documentation/rn-see-whats-new-c'
feedback_page 'http://community.mozy.com/t5/forums/postpage/board-id/SupportSuggestionBox'

# protection
is_protected_by https

# reliability
can_be_used_offline no

# reputation
established_in 2005

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
  provider_name 'EMC Corporation'

  headquarters do
    name 'EMC Corporation'
    country_code 'US'
    street_address '176 South St'
    locality 'Hopkinton'
    region 'Massachussets'
    postal_code '01748'
  end

  subsidiary do
    name 'EMC Deutschland GmbH'
    country_code 'DE'
    street_address 'Am Kronberger Hang 2a'
    locality 'Schwalbach/Taunus'
    postal_code '65824'
  end

  subsidiary do
    name 'Mozy, Inc.'
    country_code 'US'
    street_address '505 1st Ave S'
    locality 'Seattle'
    region 'Washington'
    postal_code '98104'
  end

  subsidiary do
    name 'Mozy International Limited'
    country_code 'IE'
    street_address 'IDA Industrial Estate'
    locality 'Cork'
  end

end

datacenter do
  country_code 'US'
  locality 'Salt Lake City'
  region 'Utah'
end

two_factor_auth no
sso no


file_locking no
permission_revocation yes
granular_permission yes


audit_option audit_log

certification soc_1_ssae_16
certification iso_27001

monitoring yes

data_encryption user_only, container_based, blowfish
transmission_encryption tlsv1_2


deduplication_type file_level
deduplication_type single_user
deduplication_type client_side

#replication yes
delta_encoding no

#location :data_location

max_file_size "1 TB"
max_storage_capacity "1 TB"

#version_control no
compression no


#availability "%"
#reliability "%"


multi_tenancy no

compatible_operating_system windows, 'recent'
compatible_operating_system mac_osx, 'recent'

mobile_device android
mobile_device iphone
mobile_device ipad

