type :jurisdiction

jurisdiction :european_union
jurisdiction :safe_harbour

type :location do
  string :name

  string :country_code
  string :region
  string :locality
  string :po_number
  string :postal_code
  string :street_address

  #jurisdiction will be filled automatically sometime in the future
  jurisdiction
end