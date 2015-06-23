# base
service_name 'Microsoft Azure'

# characteristics
cloud_service_model iaas

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

# interop
documentation 'http://azure.microsoft.com/de-de/documentation/services/storage/'

compatible_browser internet_explorer, '7'
compatible_browser firefox, 'recent'
compatible_browser chrome, 'recent'
compatible_browser safari, '5', annotation: 'on Mac'

# dynamic

# optimizing
maintenance_free
past_release_notes 'https://msdn.microsoft.com/en-us/library/azure/dn627519.aspx'
feedback_page 'https://plus.google.com/+GoogleDrive/posts'

# portability

# protection
is_protected_by https

# reliability
can_be_used_offline yes, annotation: ''

# reputation
established_in 2006

# trust
provider do
  company_type plc
  employs 12000
  partner_network   last_years_revenue '4600000000 $'
  report financial_statement, quarterly

  reference_customer 'Easyjet' do
    url 'http://azure.microsoft.com/en-us/case-studies/customer-stories-easyjet/'
  end

  reference_customer 'all3media' do
    url 'http://azure.microsoft.com/en-us/case-studies/all3media/'
  end

  reference_customer 'Towers Watson' do
    url 'http://azure.microsoft.com/en-us/case-studies/customer-stories-towerswatson/'
  end

  reference_customer 'MYOB' do
    url 'http://azure.microsoft.com/en-us/case-studies/customer-stories-myob/'
  end

  reference_customer 'Portal Solutions' do
    url 'http://azure.microsoft.com/en-us/case-studies/customer-stories-portalsolutions/'
  end

  reference_customer 'Presence Health' do
    url 'http://azure.microsoft.com/en-us/case-studies/customer-stories-presencehealth/'
  end

  reference_customer 'Dillen Bouwteam' do
    url 'http://azure.microsoft.com/en-us/case-studies/customer-stories-dillenbouwteam/'
  end
end