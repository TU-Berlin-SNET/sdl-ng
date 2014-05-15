type :reference_customer do
  string :name
  url
  integer :users
  description
end

type :company_type

company_type :plc

type :initiative do
  url
end

type :report

report :financial_statement

type :period

period :daily
period :weekly
period :biweekly
period :monthly
period :bimonthly
period :quarterly
period :halfyearly
period :yearly

type :reporting_information do
  report
  period
end

service_properties do
  company_type
  number :employs
  url :partner_network
  list_of_reference_customers
  money :last_years_revenue
  list_of_initiatives
  list_of_reporting_information :reports
end