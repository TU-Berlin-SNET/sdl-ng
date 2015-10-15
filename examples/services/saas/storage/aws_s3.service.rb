# base
service_name 'Amazon Simple Storage Service (Amazon S3)'

service_category storage

# characteristics
cloud_service_model iaas
#add_on_repository 'https://www.google.com/enterprise/marketplace/home', 1000

# charging
is_charged_by user_account

# compliance
status_page 'http://status.aws.amazon.com'
public_service_level_agreement 'http://aws.amazon.com/s3/sla/'

# delivery
is_billed monthly
is_charged after_use
payment_option credit_card

# dynamics
dynamic do
  # Fetch a list of features from the AWS detail page
  fetch_from_url('http://aws.amazon.com/s3/details', 'div.parsys h4').each do |header|
    # Skip empty features (e.g. "more information...")
    next if header.search('~p')[0].blank?

    # Extract Google Apps Features
    feature header.content.strip, header.search('~p')[0]
  end
end

# interop
documentation 'http://aws.amazon.com/documentation/s3/'
rest_interface 'http://docs.aws.amazon.com/AmazonS3/latest/API/APIRest.html'
soap_interface 'http://docs.aws.amazon.com/AmazonS3/latest/API/APISoap.html'

#compatible_browser firefox, 'recent'

# optimizing
maintenance_free
past_release_notes 'http://aws.amazon.com/releasenotes/Amazon%20S3'
feedback_page 'https://forums.aws.amazon.com/forum.jspa?forumID=24'

# protection
is_protected_by https

# reliability
can_be_used_offline no

# reputation
established_in 2006

# trust
provider do
  company_type plc
  employs 154100
  partner_network 'http://aws.amazon.com/solutions/case-studies/'
  last_years_revenue '88990000000 $'
  report financial_statement, yearly

  reference_customer 'NASDAQ OMX FinQloud' do
    url 'http://aws.amazon.com/solutions/case-studies/nasdaq-finqloud/'
  end

  reference_customer 'Netflix' do
    url 'http://aws.amazon.com/solutions/case-studies/netflix/'
    users 2022
  end

  reference_customer 'SmugMug' do
    url 'http://aws.amazon.com/solutions/case-studies/smugmug/'
  end

  reference_customer 'WeTransfer' do
    url 'http://aws.amazon.com/solutions/case-studies/wetransfer/'
    users 14
  end

  reference_customer 'Pinterest' do
    url 'http://aws.amazon.com/solutions/case-studies/pinterest/'
    users 48000000
  end
end

#storage security
security do
  authentication do
    two_factor_auth yes
    sso yes
  end

  authorization do
    file_locking no, annotation: 'https://forums.aws.amazon.com/thread.jspa?threadID=14189'
    permission_revocation yes, annotation: 'http://docs.aws.amazon.com/IAM/latest/UserGuide/IAMBestPractices.html'
    granular_permission yes, annotation: 'http://docs.aws.amazon.com/IAM/latest/UserGuide/IAM_UseCases.html#UseCase_S3'
  end

  certification sas_70_ii

  audit_option audit_log
  monitoring yes
  transmission_encryption 'TLS', '1.2'
end

#storage properties
storage_properties do
  deduplication_type block_level
  deduplication_type single_user
  deduplication_type server_side

  replication yes
  delta_encoding no

  #location :data_location

  max_file_size '5 TB'
  max_storage_capacity '∞'

  version_control yes
  compression yes
end

availability '99.99%'
reliability '99.999999999%'

#storage features
storage_features do
  sharing public_link

  multi_tenancy yes

  platform_compatibility do

    interface android
    interface ios
    interface java
    interface javascript
    interface net
    interface php
    interface python
    interface ruby

    #mobile_device kindle
  end
end