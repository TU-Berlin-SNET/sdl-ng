# base
service_name 'SharePlan'

service_category storage

# characteristics
cloud_service_model saas
#add_on_repository 'https://www.google.com/enterprise/marketplace/home', 1000

# charging
is_charged_by user_account

# compliance
#status_page ''
public_service_level_agreement 'http://support.code42.com/Administrator/Support#Service_Level_Agreement_(SLA)'

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
documentation 'http://support.code42.com/CrashPlan'
rest_interface 'http://support.code42.com/Administrator/4/Monitoring_And_Managing/Code42_EDGE_API'

compatible_browser firefox, 'recent'
compatible_browser chrome, 'recent'
compatible_browser safari, '5', annotation: 'on Mac'
compatible_browser internet_explorer, '9'

# optimizing
#maintenance_window, annotation: 'http://support.code42.com/Terms_And_Conditions/Scheduled_Maintenance'
past_release_notes 'http://support.code42.com/Release_Notes/'
feedback_page 'http://support.code42.com'

# protection
is_protected_by https

# reliability
can_be_used_offline yes, annotation: ''

# reputation
established_in 2001

# trust
provider do
  company_type plc
  employs 426
  partner_network 'https://www.code42.com/customer-success/'
  #last_years_revenue ' $'
  report financial_statement, quarterly

  reference_customer 'Washington University in St. Louis', 'https://www.code42.com/customer-success/washington-university-st-louis/'
  reference_customer 'Centenary Institute', 'https://www.code42.com/customer-success/centenary-institute/'
  reference_customer 'Grant Street Group', 'https://www.code42.com/customer-success/grant-street-group/'
  reference_customer 'TRAX International', 'https://www.code42.com/customer-success/trax/'
  reference_customer 'Fuller Theological Seminary', 'https://www.code42.com/customer-success/fuller-theological-seminary/'
  reference_customer 'Columbia Business School', 'https://www.code42.com/customer-success/columbia-business-school/'
  reference_customer 'Lockheed Martin', 'https://www.code42.com/customer-success/lockheed-martin/'
  reference_customer 'TaylorMade', 'https://www.code42.com/customer-success/taylormade/'
  reference_customer 'California Baptist University', 'https://www.code42.com/customer-success/california-baptist-university/'
  reference_customer 'The Ohio State University', 'https://www.code42.com/customer-success/ohio-state-university/'
  reference_customer 'Oceanographic Institute', 'https://www.code42.com/customer-success/oceanographic-institute/'
  reference_customer 'Colby College', 'https://www.code42.com/customer-success/colby-college/'
  reference_customer 'Internet2', 'https://www.code42.com/customer-success/internet-2/'
  reference_customer 'Augsburg College', 'https://www.code42.com/customer-success/augsburg-college/'
  reference_customer 'Lifeway Christian Resources', 'https://www.code42.com/customer-success/lifeway-christian-resources/'
  reference_customer 'GoKart Labs', 'https://www.code42.com/customer-success/gokart-labs/'

  reference_customer 'Zynga'
  reference_customer 'P&G'
  reference_customer 'QuickSilver'
  reference_customer 'Adobe'
  reference_customer 'yelp'
  reference_customer 'Salesforce'
  reference_customer 'SanDisk'
  reference_customer 'National Geographic'
  reference_customer 'Expedia'
  reference_customer 'Jive'
end

  authentication do
    two_factor_auth yes
    sso yes
  end

  authorization do
    file_locking yes, annotation: 'https://twitter.com/crashplan/status/136203049197764608'
    permission_revocation yes
    granular_permission yes
  end

  audit_option audit_log

  monitoring yes

  certification soc_1_ssae_16
  certification soc_2_ssae_16
  certification iso_27001

  data_encryption user_only, directory_based, blowfish
  transmission_encryption 'SSL', 'AES-128'



  deduplication_type block_level
  deduplication_type single_user
  deduplication_type client_side

  replication yes
  delta_encoding yes

  #location :data_location

  max_file_size "∞"
  max_storage_capacity "∞"

  version_control yes
  compression yes


#availability "%"
#reliability "%"


  sharing public_link
  sharing collaboration

  multi_tenancy yes

    compatible_operating_system windows, 'recent'
    compatible_operating_system mac_osx, 'recent'
    compatible_operating_system linux, 'recent'

    mobile_device android
    mobile_device iphone
    mobile_device ipad
    mobile_device windows_phone

