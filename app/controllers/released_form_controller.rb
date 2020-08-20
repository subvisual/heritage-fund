# Controllers for orchestrating the performing of
# ReleaseFormJob requests
class ReleasedFormController < ApplicationController
  http_basic_authenticate_with(
    name: Rails.configuration.x.consumer.username,
    password: Rails.configuration.x.consumer.password
  )

  protect_from_forgery with: :null_session

  # Receives Salesforce Callout payloads
  def receive
    ReleaseFormJob.perform_later(request.params, request.raw_post)
  end

end
