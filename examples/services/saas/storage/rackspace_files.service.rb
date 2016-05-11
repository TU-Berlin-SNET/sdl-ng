# base
service_name 'Rackspace Files'

service_category storage

# characteristics
cloud_service_model saas
#add_on_repository 'https://www.google.com/enterprise/marketplace/home', 1000

# charging
is_charged_by user_account

# compliance
status_page 'https://status.rackspace.com'
public_service_level_agreement 'http://www.rackspace.org/de/legal/cloud-files-sla'

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
documentation 'https://www.google.com/enterprise/apps/business/products.html#drive'
rest_interface 'http://www.rackspace.org/de/cloud/files/api'

# optimizing
#maintenance_free
past_release_notes 'https://mycloud.rackspace.com/release_notes'
feedback_page 'https://feedback.rackspace.com'

# protection
is_protected_by https

# reliability
can_be_used_offline no

# reputation
established_in 1998

# trust
provider do
  company_type incorporated
  employs 4852
  #partner_network ''
  last_years_revenue '2000000000 $'
  report financial_statement, quarterly

  reference_customer 'Transport for London', 'http://www.rackspace.com/de/customers/transport-london'
  reference_customer 'Telerik', 'http://www.rackspace.com/de/customers/telerik'
  reference_customer 'Dominos', 'http://www.rackspace.com/de/customers/dominos-pizza'
  reference_customer 'Barbour', 'http://www.rackspace.com/de/customers/barbour'
  reference_customer 'Welcome to Yorkshire', 'http://www.rackspace.com/de/customers/welcome-yorkshire'
end

two_factor_auth yes
sso yes


file_locking no
permission_revocation yes
granular_permission yes


audit_option audit_log

monitoring yes

transmission_encryption 'SSL'


#deduplication_type
replication yes
delta_encoding yes

#location :data_location

#max_file_size "5 TB"
max_storage_capacity "∞"

version_control no
compression yes


availability "99.9%"
#reliability "%"


sharing public_link

multi_tenancy yes, 50

interface java
interface net
interface php
interface python
interface ruby

