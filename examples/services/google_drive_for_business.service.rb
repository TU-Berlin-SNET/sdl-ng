# base
service_name 'Google Drive for Business'

# characteristics
cloud_service_model saas
add_on_repository 'https://www.google.com/enterprise/marketplace/home', 1000

# charging
is_charged_by user_account

# compliance
status_page 'http://www.google.com/appsstatus'
public_service_level_agreement 'http://www.google.com/apps/intl/en/terms/sla.html'

# delivery
is_billed monthly, in_advance
payment_option credit_card

# dynamics

# interop
documentation 'http://www.google.com/enterprise/apps/business/products.html#drive'
rest_interface 'https://developers.google.com/drive/'

compatible_browser firefox, 'recent'
compatible_browser chrome, 'recent'
compatible_browser safari, '5', annotation: 'on Mac'
compatible_browser internet_explorer, '9'

dynamic do
  # Fetch a list of features from the Google Apps page
  fetch_from_url('http://www.google.com/enterprise/apps/business/products.html', 'div.apps-content-set:nth-child(3) div.product-section-features h3').each do |header|
    # Skip empty features (e.g. "more information...")
    next if header.search('~p')[0].blank?

    # Extract Google Apps Features
    feature header.content.strip, header.search('~p')[0]
  end
end

# optimizing
maintenance_free
past_release_notes 'https://plus.google.com/+GoogleDrive/posts'
feedback_page 'https://plus.google.com/+GoogleDrive/posts'

# portability
{ "For documents" => [:html, :rtf, :word, :open_office, :pdf, :text],
  "For spreadsheets" => [:csv, :html, :odf, :pdf, :xls, :text],
  "For presentations" => [:pdf, :pptx, :text],
  "For drawings" => [:png, :jpeg, :svg, :pdf]
}.each do |annotation, formats_list|
  formats_list.each do |f|
    exportable_data_format f, annotation: annotation
  end
end

# protection
is_protected_by https

# reliability
can_be_used_offline yes, annotation: 'https://support.google.com/drive/answer/2375012'

# reputation
established_in 2006

# trust
company_type plc
employs 49829
partner_network 'http://www.google.de/intx/de/enterprise/apps/business/partners.html'
last_years_revenue '59820000000 $'
report financial_statement, quarterly

reference_customer 'motorola' do
  url 'https://www.youtube.com/watch?v=56ETTYvGsg4'
  users 20000
end