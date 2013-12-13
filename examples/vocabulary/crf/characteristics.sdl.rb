type :cloud_service_model
type :service_category
type :service_tag

fact :cloud_service_model do
  cloud_service_model
end

fact :service_category do
  service_category
end

fact :service_tag do
  service_tag
end

fact :add_on_repository do
  url
  integer :number_of_add_ons
end

cloud_service_model :saas
cloud_service_model :paas
cloud_service_model :iaas
cloud_service_model :haas