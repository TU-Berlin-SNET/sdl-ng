# base
service_name 'Microsoft Azure'

service_category storage

# characteristics
cloud_service_model paas
add_on_repository 'http://azure.microsoft.com/en-us/marketplace/', 3109

# charging
is_charged_by user_account

# compliance
status_page 'http://status.azure.com/'
public_service_level_agreement 'http://azure.microsoft.com/en-us/support/legal/sla/'

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
documentation 'http://azure.microsoft.com/de-de/documentation/services/storage/'
rest_interface 'https://msdn.microsoft.com/en-us/library/dd179355.aspx'

# optimizing
maintenance_free
past_release_notes 'https://msdn.microsoft.com/en-us/library/azure/dn627519.aspx'
feedback_page 'https://plus.google.com/+GoogleDrive/posts'

# protection
is_protected_by https

# reliability
can_be_used_offline yes, annotation: ''

# reputation
established_in 2006

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

  authentication do
    two_factor_auth yes
    sso yes
  end

  authorization do
    file_locking no
    permission_revocation yes
    granular_permission yes
  end

  audit_option audit_log

  monitoring yes

  data_encryption provider_only, container_based, aes
  transmission_encryption 'TLS', '1.2'



  deduplication_type block_level
  deduplication_type single_user
  deduplication_type server_side

  replication yes
  delta_encoding yes

  #location :data_location

  max_file_size "5 TB"
  max_storage_capacity "∞"

  version_control yes
  compression yes


availability "99.9 %"
#reliability "%"



  multi_tenancy yes

    compatible_operating_system windows, 'recent'
    compatible_operating_system mac_osx, 'recent'

    interface net
    interface java
    interface php
    interface ruby
    interface python
    interface javascript


