type :cloud_service_model
type :service_category

service_category :storage
service_category :virtual_machine

cloud_service_model :saas
cloud_service_model :paas
cloud_service_model :iaas
cloud_service_model :haas

service_properties do
  cloud_service_model

  list_of_service_categories

  list_of_strings :service_tags

  add_on_repository do
    url
    integer :number_of_add_ons
  end
end