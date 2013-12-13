fact :data_location_transparency

fact :data_location do
  location
end

fact :data_deletion_policy

type :key_control

fact :data_encryption do
  key_control
end

key_control :user_only
key_control :provider_only
key_control :shared

type :audit_option

fact :audit_option do
  audit_option
end

audit_option :audit_log

fact :status_page do
  url
end

fact :service_level_agreement do
  subfact :public_service_level_agreement do
    url
  end
end