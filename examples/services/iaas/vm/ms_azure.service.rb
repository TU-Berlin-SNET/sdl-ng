# base
service_name 'Microsoft Azure'

# characteristics
cloud_service_model iaas
service_category vm

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
  last_years_revenue '4600000000 $'
  report financial_statement, quarterly

  reference_customer 'Easyjet', 'http://azure.microsoft.com/en-us/case-studies/customer-stories-easyjet/'
  reference_customer 'all3media','http://azure.microsoft.com/en-us/case-studies/all3media/'
  reference_customer 'Towers Watson', 'http://azure.microsoft.com/en-us/case-studies/customer-stories-towerswatson/'
  reference_customer 'MYOB' ,'http://azure.microsoft.com/en-us/case-studies/customer-stories-myob/'
  reference_customer 'Portal Solutions' ,'http://azure.microsoft.com/en-us/case-studies/customer-stories-portalsolutions/'
  reference_customer 'Presence Health' ,'http://azure.microsoft.com/en-us/case-studies/customer-stories-presencehealth/'
  reference_customer 'Dillen Bouwteam' ,'http://azure.microsoft.com/en-us/case-studies/customer-stories-dillenbouwteam/'
end