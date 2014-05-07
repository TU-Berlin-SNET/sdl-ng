type :jurisdiction

jurisdiction :european_union
jurisdiction :safe_harbour

type :country do
  jurisdiction
end

country :germany do
  jurisdiction :european_union
end

type :address do
  list_of_strings :address_lines
end

type :location do
  subtype :specific_location do
    country
    address
  end

  subtype :unspecific_location do
    jurisdiction
  end
end