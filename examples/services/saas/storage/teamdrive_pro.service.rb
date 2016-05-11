# base
service_name 'Teamdrive Pro'

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
#documentation ''
#rest_interface ''

# optimizing
maintenance_free
past_release_notes 'http://forum.teamdrive.net/viewforum.php?f=2'
#feedback_page ''

# protection
is_protected_by https

# reliability
can_be_used_offline yes

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

  certification sas_70_ii
  certification iso_27001

  monitoring yes

  data_encryption user_only, container_based, aes
  transmission_encryption 'TLS'



  #deduplication_type
  replication yes
  delta_encoding no

  #location :data_location

  max_file_size "5 TB"
  max_storage_capacity "10 GB"

  version_control yes
  compression yes


availability "%"
reliability "%"


  sharing public_link
  sharing collaboration

  multi_tenancy yes

    compatible_operating_system windows, 'recent'
    compatible_operating_system mac_osx, 'recent'
    compatible_operating_system linux, 'recent'

    mobile_device android
    mobile_device iphone
    mobile_device ipad

