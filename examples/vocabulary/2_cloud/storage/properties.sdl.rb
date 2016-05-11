type :deduplication_type do
  subtype :deduplication_level
  subtype :deduplication_user
  subtype :deduplication_side
end

deduplication_level :block_level
deduplication_level :file_level

deduplication_user :single_user
deduplication_user :cross_user

deduplication_side :server_side
deduplication_side :client_side

service_properties do
  list_of_deduplication_types
  boolean :replication
  boolean :delta_encoding

  location :data_location

  string :max_file_size
  string :max_storage_capacity

  boolean :version_control
  boolean :compression

  string :sla

  string :durability
  string :delay
  string :packet_loss
  string :fault_tolerance
  string :bandwidth
end