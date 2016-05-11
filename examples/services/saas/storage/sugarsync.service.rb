# base
service_name 'SugarSync'

service_category storage

# characteristics
cloud_service_model saas

# charging
is_charged_by user_account

# compliance
status_page 'https://www.sugarsync.com/servicestatus'
public_service_level_agreement 'https://www.sugarsync.com/terms.html'

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
documentation 'https://www.sugarsync.com/developer'
rest_interface 'https://www.sugarsync.com/dev/home.html#apinew'

compatible_browser firefox, 'recent'
compatible_browser chrome, 'recent'
compatible_browser safari, 'recent'
compatible_browser internet_explorer, 'recent'

# optimizing
maintenance_free
past_release_notes 'https://helpdesk.sugarsync.com/hc/en-us/articles/201573224-What-s-new-in-the-new-SugarSync-'
feedback_page 'https://plus.google.com/+GoogleDrive/posts'

# protection
is_protected_by https

# reliability
can_be_used_offline yes

# reputation
established_in 2004

# trust
provider do
  company_type plc
  employs 200
  partner_network 'https://www.sugarsync.com/partners/'
  #last_years_revenue '59820000000 $'
  #report financial_statement, quarterly
end

  authentication do
    two_factor_auth no
    sso no
  end

  authorization do
    file_locking no
    permission_revocation yes
    granular_permission yes
  end

  monitoring yes

  data_encryption provider_only, directory_based, aes
  transmission_encryption 'SSL', '3.3'



  #deduplication_type
  #replication yes
  #delta_encoding no

  #location :data_location

  max_file_size 'unlimited'
  max_storage_capacity "∞"

  version_control yes
  #compression yes


#availability "%"
#reliability "%"


  sharing public_link
  sharing collaboration

  multi_tenancy yes

    compatible_operating_system windows, 'recent'
    compatible_operating_system mac_osx, 'recent'

    mobile_device blackberry
    mobile_device iphone
    mobile_device ipad
    mobile_device kindle

