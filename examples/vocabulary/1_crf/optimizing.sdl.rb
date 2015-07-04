type :maintenance_free

type :maintenance_notification

maintenance_notification :user_portal
maintenance_notification :email

type :maintenance_window do
  timespan
end

service_properties do
  maintenance_free
  maintenance_window
  maintenance_notification

  url :future_roadmap
  url :past_release_notes
  url :feedback_page
end