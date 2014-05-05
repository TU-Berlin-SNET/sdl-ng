fact :maintenance do
  subfact :maintenance_window do
    #timespan
  end

  subfact :maintenance_free
end

fact :continuous_service_improvement do
  url

  subfact :future_roadmap
  subfact :past_release_notes
  subfact :feedback_page
end