require 'restforce'

class ApplicationToSalesforceJob < ApplicationJob
  class SalesforceApexError < StandardError; end
  queue_as :default

  # @param [Project] project
  def perform(project)
    logger.info("Submitting Project ID: #{project.id} to Salesforce")
    project.update(submitted_on: DateTime.now)
    client = Restforce.new(
        username: Rails.configuration.x.salesforce.username,
        password: Rails.configuration.x.salesforce.password,
        security_token: Rails.configuration.x.salesforce.security_token,
        client_id: Rails.configuration.x.salesforce.client_id,
        client_secret: Rails.configuration.x.salesforce.client_secret,
        host: Rails.configuration.x.salesforce.host,
        api_version: '48.0'
    )
    @json = project.to_salesforce_json
    @response = client.post('/services/apexrest/PortalData', @json,  {'Content-Type'=>'application/json'})
    @response_body_obj = JSON.parse(@response&.body)
    is_successful = @response_body_obj&.dig('status') == 'Success'
    if(is_successful)
      project.update(
          salesforce_case_number: @response_body_obj.dig('caseNumber'),
          salesforce_case_id: @response_body_obj.dig('caseId'),
          project_reference_number: @response_body_obj.dig('projectRefNumber')
      )
      project.organisation.update(
          salesforce_account_id: @response_body_obj.dig('accountId')
      )
    else
      raise SalesforceApexError("Error response from Salesforce #{@response_body_obj}")
    end
  end
end
