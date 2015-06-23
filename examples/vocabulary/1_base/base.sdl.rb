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

service_properties do
  string :service_name
  provider

  list_of_variants
end