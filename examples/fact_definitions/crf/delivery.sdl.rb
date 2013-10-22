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