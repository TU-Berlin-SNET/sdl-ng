type :data_format

data_format :csv
data_format :xls
data_format :html
data_format :rtf
data_format :word
data_format :open_office
data_format :pdf
data_format :text
data_format :odf
data_format :pptx
data_format :png
data_format :jpeg
data_format :svg

type :data_capability do
  data_format

  subtype :export_capability
  subtype :import_capability
end

service_properties do
  list_of_export_capabilities :can_export
  list_of_import_capabilities :can_import
end
