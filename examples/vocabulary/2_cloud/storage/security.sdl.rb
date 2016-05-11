type :certification

certification :isae_3402_ii_soc_2
certification :soc_1_ssae_16
certification :soc_2_ssae_16
certification :sas_70_ii
certification :iso_27001

type :encryption_base

encryption_base :container_based
encryption_base :directory_based

type :encryption_algorithm

encryption_algorithm :aes
encryption_algorithm :blowfish
encryption_algorithm :rsa
encryption_algorithm :serpent
encryption_algorithm :twofish

type :data_encryption do
  key_control
  encryption_base
  encryption_algorithm
end

type :transmission_encryption

transmission_encryption :ssl
transmission_encryption :sslv3
transmission_encryption :tlsv1
transmission_encryption :tlsv1_2

jurisdiction :hipaa
jurisdiction :fisma
jurisdiction :ferpa
jurisdiction :safe_harbor

service_properties do
  boolean :two_factor_auth
  boolean :sso

  boolean :file_locking
  boolean :permission_revocation
  boolean :granular_permission

  list_of_audit_options
  list_of_certifications
  boolean :monitoring

  data_encryption
  transmission_encryption
end