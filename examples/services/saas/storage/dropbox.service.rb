# base
service_name 'Dropbox'

service_category storage

# characteristics
cloud_service_model saas
add_on_repository 'https://www.dropbox.com/business/resources/app-integrations', 300000

# charging
is_charged_by user_account

# compliance
#status_page ''
public_service_level_agreement 'https://www.dropbox.com/terms#business_agreement'

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
documentation 'https://www.dropbox.com/developers'
rest_interface 'https://www.dropbox.com/developers/core'

compatible_browser firefox, 'recent'
compatible_browser chrome, 'recent'
compatible_browser safari, 'recent'
compatible_browser internet_explorer, 'recent'

# optimizing
maintenance_free
past_release_notes 'https://www.dropbox.com/release_notes'
#feedback_page 'https://plus.google.com/+GoogleDrive/posts'

# protection
is_protected_by https

# reliability
can_be_used_offline yes, annotation: 'https://www.dropbox.com/help/30'

# reputation
established_in 2007

# trust
provider do
    provider_name 'Dropbox, Inc.'
  #company_type plc
  employs 971
  partner_network 'https://www.dropbox.com/business/customers'
  #last_years_revenue '59820000000 $'
  #report financial_statement, quarterly

  headquarters do
    name 'Dropbox, Inc.'
    country_code 'US'
    street_address '333 Brannan St'
    locality 'Los Angeles'
    region 'California'
    postal_code '94107'
  end

  subsidiary do
    name 'Dropbox, Inc.'
    country_code 'US'
    locality 'Austin'
    region 'Texas'
  end
end

two_factor_auth yes


file_locking no
permission_revocation yes


certification sas_70_ii

data_encryption provider_only, directory_based, aes
transmission_encryption tlsv1_2


deduplication_type file_level
deduplication_type single_user
deduplication_type server_side

replication yes
delta_encoding yes

#location :data_location

max_file_size "storage size"
compression yes


#availability "%"
#reliability "%"


sharing public_link
sharing collaboration

multi_tenancy no

compatible_operating_system windows, 'recent'
compatible_operating_system mac_osx, 'recent'
compatible_operating_system linux, 'recent'

interface android
interface ios
interface java
interface osx
interface php
interface python
interface ruby

mobile_device blackberry
mobile_device iphone
mobile_device ipad
mobile_device kindle
mobile_device windows_phone


variant :free do
  service_name 'Dropbox Free'

  public_service_level_agreement 'https://www.dropbox.com/terms#terms'

  sso no
end

granular_permission no


monitoring no


max_storage_capacity "100 GB"

version_control yes, annotation: '30 days'


variant :business do
  service_name 'Dropbox for Business'

  add_on_repository 'https://www.dropbox.com/business/resources/app-integrations', 300000

  public_service_level_agreement 'https://www.dropbox.com/terms#business_agreement'

  provider do
    reference_customer 'BCBG MAX AZRIA GROUP', 'https://www.dropbox.com/business/customers/case-study-bcbg'
    reference_customer 'Vita Coco', 'https://www.dropbox.com/business/customers/case-study-vita-coco'
    reference_customer 'CentricProjects', 'https://www.dropbox.com/business/customers/case-study-centric-project'
    reference_customer 'Kayak', 'https://www.dropbox.com/business/customers/case-study-kayak'
    reference_customer 'foursquare', 'https://www.dropbox.com/business/customers/case-study-foursquare'
    reference_customer 'Asana', 'https://www.dropbox.com/business/customers/case-study-asana'
    reference_customer 'Huge', 'https://www.dropbox.com/business/customers/case-study-huge'
    reference_customer 'USA Gymnastics', 'https://www.dropbox.com/business/customers/case-study-usa-gymnastics'
    reference_customer 'appen', 'https://www.dropbox.com/business/customers/case-study-appen-butler-hill'
    reference_customer 'Valiant', 'https://www.dropbox.com/business/customers/case-study-valiant-entertainment'
    reference_customer 'Radiolab', 'https://www.dropbox.com/business/customers/case-study-radiolab'
    reference_customer 'Refinery29', 'https://www.dropbox.com/business/customers/case-study-refinery-29'

    reference_customer 'National Geographic'
    reference_customer 'Spotify'
    reference_customer 'zendesk'
    reference_customer 'Citizen'
    reference_customer 'Rockstar'
    reference_customer 'dictonary.com'
    reference_customer 'Eventbrite'
  end

  sso yes
end

granular_permission yes


audit_option audit_log

monitoring yes

max_storage_capacity "∞"

version_control yes, annotation: 'unlimited'

