type :support_availability

support_availability :work_hours
support_availability :extended
support_availability :fulltime

type :free_trial do
  boolean :has_free_trial
  string :free_trial_period
end

service_properties do
  free_trial
  support_availability
end