# base
service_name 'Amazon Elastic Compute Cloud (Amazon EC2)'

# characteristics
cloud_service_model iaas
service_category vm

# charging
is_charged_by user_account
discounts yes, annotation: 'Upto 75% for Reserved instances'

#procurement
procurement_model on_demand
procurement_model reserved
procurement_model spot


# compliance
status_page 'http://status.aws.amazon.com'
public_service_level_agreement 'http://aws.amazon.com/ec2/sla/'

# delivery
is_billed monthly
is_charged after_use
payment_option credit_card

# dynamics
dynamic do
  # Fetch a list of features from the AWS detail page
  fetch_from_url('http://aws.amazon.com/ec2/details/', 'div.parsys h4').each do |header|
    # Skip empty features (e.g. "more information...")
    next if header.search('~p')[0].blank?

    # Extract Google Apps Features
    feature header.content.strip, header.search('~p')[0]
  end
end

# interop
documentation 'http://aws.amazon.com/documentation/ec2/'

compatible_browser firefox, 'the three latest versions'
compatible_browser chrome, 'the three latest versions'
compatible_browser safari, '6+', annotation: 'on Mac'
compatible_browser internet_explorer, '8+'

# optimizing
maintenance_notification email
past_release_notes 'https://aws.amazon.com/releasenotes/Amazon-EC2'

# protection
is_protected_by https

#provider management
free_trial yes, '12 months'

# reliability

# reputation
established_in 2006

# trust
provider do
  company_type plc
  partner_network 'http://aws.amazon.com/solutions/case-studies/'
  provider_announcement 'http://aws.amazon.com/new/'

  reference_customer 'Foursquare' do
    url 'http://aws.amazon.com/solutions/case-studies/foursquare/'
  end
  reference_customer 'Bankinter' do
    url 'http://aws.amazon.com/solutions/case-studies/bankinter/'
  end
  reference_customer 'Netflix' do
    url 'http://aws.amazon.com/solutions/case-studies/netflix/'
  end
  reference_customer 'Nasa/JPL Mars Curiosity Mission' do
    url 'http://aws.amazon.com/solutions/case-studies/nasa-jpl-curiosity/'
  end
  reference_customer 'Autodesk' do
    url 'http://aws.amazon.com/solutions/case-studies/autodesk/'
  end
  reference_customer 'Animoto' do
    url 'http://aws.amazon.com/solutions/case-studies/animoto/'
  end
end

# storage security
authentication do
  two_factor_auth yes
  sso yes
end

authorization do
  permission_revocation yes, annotation: 'http://docs.aws.amazon.com/IAM/latest/UserGuide/IAMBestPractices.html'
  granular_permission yes, annotation: 'http://docs.aws.amazon.com/IAM/latest/UserGuide/IAM_UseCases.html#UseCase_EC2'
end

# storage properties

# storage features
