type :charge_unit

charge_unit :user_account
charge_unit :floating_license

type :billing_cycle

billing_cycle :per_hour
billing_cycle  :per_month

type :minimum_billing_cycle do
  billing_cycle
  string :billing_rate
end


service_properties do
  charge_unit :is_charged_by
  list_of_minimum_billing_cycles
  boolean :discounts
end

