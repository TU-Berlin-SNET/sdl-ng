type :data_capability_operation

type :data_format

fact :data_capability do
  data_capability_operation :operation
  data_format :format
end

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

data_capability_operation :export
data_capability_operation :import