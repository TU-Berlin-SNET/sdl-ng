# base
service_name 'Box Starter'

service_category storage

# characteristics
cloud_service_model saas
#add_on_repository 'https://www.google.com/enterprise/marketplace/home', 1000

# charging
is_charged_by user_account

# compliance
status_page 'https://status.box.com'
public_service_level_agreement 'https://www.box.com/legal/termsofservice/'

# delivery
is_billed monthly
is_charged after_use
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
documentation 'http://developers.box.com/docs-overview/'
rest_interface 'https://developers.box.com/docs/'

compatible_browser firefox, 'the two latest versions'
compatible_browser chrome, 'the two latest versions'
compatible_browser safari, 'the two latest versions', annotation: 'on Mac'
compatible_browser internet_explorer, 'the two latest versions'

# optimizing
maintenance_free
past_release_notes 'https://support.box.com/hc/communities/public/questions/200762743?'
feedback_page 'https://www.box.com/quote/'

# protection
is_protected_by https

# reliability
can_be_used_offline yes

# reputation
established_in 2005

# trust
provider do
  company_type plc
  employs 750
  partner_network 'https://www.box.com/customers/'
  last_years_revenue '153800000 $'
  report financial_statement, quarterly

  reference_customer 'P&G'
  reference_customer 'Pandora'
  reference_customer 'Schneider Electric'
  reference_customer 'Rosetta Stone'
  reference_customer 'Grey Group'
end

security do
  authentication do
    two_factor_auth yes
    sso no
  end

  authorization do
    file_locking yes
    permission_revocation yes
    granular_permission yes
  end

  #audit_option audit_log

  monitoring no

  transmission_encryption 'SSL', 'SHA-265'
end

storage_properties do
  # deduplication_type block_level
  # deduplication_type single_user
  # deduplication_type server_side

  replication no
  delta_encoding no

  #location :data_location

  max_file_size '2 GB'
  max_storage_capacity '100 GB'

  version_control yes, annotation: '25'
  compression no
end

#availability "%"
#reliability "%"

storage_features do
  sharing public_link
  sharing collaboration

  multi_tenancy yes, 10
  platform_compatibility do
    compatible_operating_system windows, 'the two latest versions'
    compatible_operating_system mac_osx, 'the two latest versions'

    interface android
    interface ios
    interface osx

    mobile_device android
    mobile_device blackberry
    mobile_device iphone
    mobile_device ipad
    mobile_device windows_phone
  end
end