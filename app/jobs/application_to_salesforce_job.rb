require 'restforce'

class ApplicationToSalesforceJob < ApplicationJob
  queue_as :default

  # @param [Project] project
  def perform(project)
    puts(project.id)
    client = Restforce.new(
        username: Rails.configuration.x.salesforce.username,
        password: Rails.configuration.x.salesforce.password,
        security_token: Rails.configuration.x.salesforce.security_token,
        client_id: Rails.configuration.x.salesforce.client_id,
        client_secret: Rails.configuration.x.salesforce.client_secret,
        host: Rails.configuration.x.salesforce.host,
        api_version: '48.0'
    )

    @response = client.post('/services/apexrest/PortalData', project.to_salesforce_json,  {'Content-Type'=>'application/json'})
  end
end
