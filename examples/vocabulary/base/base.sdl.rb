type :timespan do
  time :start
  time :end
end

type :provider do
  string :provider_name
end

service_properties do
  string :service_name
  provider
end