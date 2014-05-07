type :key_control

key_control :user_only
key_control :provider_only
key_control :shared

type :data_encryption do
  key_control
end

type :audit_option

audit_option :audit_log

service_properties do
  location :data_location

  url :data_deletion_policy
  url :status_page
  url :public_service_level_agreement

  data_encryption

  list_of_audit_options
end