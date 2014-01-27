name 'Google Drive for Business'

has_documentation 'http://www.google.com/enterprise/apps/business/products.html#drive'

has_add_on_repository 'https://www.google.com/enterprise/marketplace/home', 1000

has_cloud_service_model saas

has_communication_protection https

has_status_page 'http://www.google.com/appsstatus'

has_public_service_level_agreement 'http://www.google.com/apps/intl/en/terms/sla.html'

maintenance_free

has_past_release_notes 'https://plus.google.com/+GoogleDrive/posts'
has_feedback_page 'https://plus.google.com/+GoogleDrive/posts'

has_establishing_year 2006

has_rest_interface annotation: 'https://developers.google.com/drive/'

has_offline_capability annotation: 'https://support.google.com/drive/answer/2375012'

is_billed monthly, in_advance

has_payment_option credit_card

has_browser_interface do
  compatible_browser firefox, 'recent'
  compatible_browser chrome, 'recent'
  compatible_browser safari, '5', annotation: 'on Mac'
  compatible_browser internet_explorer, '9'
end

{ "For documents" => [:html, :rtf, :word, :open_office, :pdf, :text],
  "For spreadsheets" => [:csv, :html, :odf, :pdf, :xls, :text],
  "For presentations" => [:pdf, :pptx, :text],
  "For drawings" => [:png, :jpeg, :svg, :pdf]
}.each do |annotation, formats_list|
  formats_list.each do |f|
    has_export_capability f, annotation: annotation
  end
end

# Fetch a list of features from the Google Apps page
fetch_from_url('http://www.google.com/enterprise/apps/business/products.html', 'div.apps-content-set:nth-child(3) div.product-section-features h3').each do |header|
  # Skip empty features (e.g. "more information...")
  next if header.search('~p')[0].blank?

  # Extract Google Apps Features
  has_feature header.content.strip, header.search('~p')[0]
end
