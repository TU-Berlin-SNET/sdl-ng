# base
service_name 'Rackspace Cloud Servers'

# characteristics
cloud_service_model iaas
service_category vm

# charging
is_charged_by user_account

# compliance
status_page 'https://status.rackspace.com'
public_service_level_agreement 'http://www.rackspace.com/information/legal/cloud/sla'

# delivery
is_billed monthly
is_charged after_use
payment_option credit_card

# dynamics
dynamic do
# Fetch a list of features from the Google Apps page
  fetch_from_url('http://www.rackspace.com/cloud/servers/features', 'div.maia-col-6.text div.vcenter h2').each do |header|
# Skip empty features (e.g. "more information...")
    next if header.search('~p')[0].blank?

# Extract Google Apps Features
    feature header.content.strip, header.search('~p')[0]
  end
end

# interop
documentation 'http://docs.rackspace.com/'
rest_interface 'http://www.rackspace.org/de/cloud/files/api'

# optimizing
#maintenance_free
past_release_notes 'https://mycloud.rackspace.com/release_notes'
feedback_page 'https://feedback.rackspace.com'

# protection
is_protected_by vpn

# reliability
can_be_used_offline no

# reputation
established_in 1998

# trust
provider do
  company_type incorporated
  employs 4852
  partner_network 'http://www.rackspace.com/de/customers'
  last_years_revenue '2000000000 $'
  report financial_statement, quarterly

  reference_customer 'Transport for London', 'http://www.rackspace.com/de/customers/transport-london'
  reference_customer 'Telerik', 'http://www.rackspace.com/de/customers/telerik'
  reference_customer 'Dominos', 'http://www.rackspace.com/de/customers/dominos-pizza'
  reference_customer 'Barbour', 'http://www.rackspace.com/de/customers/barbour'
  reference_customer 'Welcome to Yorkshire', 'http://www.rackspace.com/de/customers/welcome-yorkshire'
end

#security
two_factor_auth yes


file_locking no
permission_revocation yes
granular_permission yes


audit_option audit_log

monitoring yes

transmission_encryption ssl#


#storage properties

max_storage_capacity "∞"


#storage_features


compatible_operating_system windows, 'Windows Server 2008, Windows Server 2011'
compatible_operating_system linux, 'recent'

#Rackspace Mobile Application CPanel
mobile_device iphone
mobile_device ipad
mobile_device windows_phone



  
