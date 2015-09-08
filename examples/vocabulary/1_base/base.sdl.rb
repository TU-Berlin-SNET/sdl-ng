type :timespan do
  time :start
  time :end
end

type :provider do
  string :provider_name
end

type :service do
  subtype :variant do
    string :variant_name
  end
end

type :service_category do
  string :category_name
end

service_properties do
  string :service_name
  provider

  list_of_variants
  list_of_service_categories
end