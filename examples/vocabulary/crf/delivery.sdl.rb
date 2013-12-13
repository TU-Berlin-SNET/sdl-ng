type :billing_term
type :payment_term
type :payment_option

fact :bill do
  billing_term
  payment_term
end

fact :payment_option do
  payment_option
end

billing_term :monthly
billing_term :annually

payment_term :in_advance
payment_term :after_use

payment_option :credit_card
payment_option :cheque
payment_option :invoice