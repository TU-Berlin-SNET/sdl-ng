name 'Google Drive for Business'

has_documentation 'http://www.google.com/enterprise/apps/business/products.html#drive'

has_rest_interface annotation: 'https://developers.google.com/drive/'

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
    has_data_capability export, f, annotation: annotation
  end
end

headers = fetch_from_url 'http://www.google.com/enterprise/apps/business/products.html', 'div.apps-content-set:nth-child(3) div.maia-col-4 h3'
headers.each do |header|
  has_feature header.content.strip, header.search('~p')[0]
end
