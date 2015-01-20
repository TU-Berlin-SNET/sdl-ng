type :billing_term
type :payment_term
type :payment_option

billing_term :monthly
billing_term :annually

payment_term :in_advance
payment_term :after_use

payment_option :credit_card
payment_option :cheque
payment_option :invoice

service_properties do
  billing_term :is_billed
  payment_term :is_charged

  list_of_payment_options
end