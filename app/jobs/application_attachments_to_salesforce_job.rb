require "faraday"
require "restforce"

# Monkey patch faraday to allow JSON in multipart POST https://stackoverflow.com/a/48700311/238230
class Faraday::Request::Multipart
  def create_multipart(env, params)
    boundary = env.request.boundary
    parts = process_params(params) { |key, value|
      if begin
        JSON.parse(value)
      rescue
        false
      end
        Faraday::Parts::Part.new(boundary, key, value, "Content-Type" => "application/json")
      else
        Faraday::Parts::Part.new(boundary, key, value)
      end
    }
    parts << Faraday::Parts::EpiloguePart.new(boundary)

    body = Faraday::CompositeReadIO.new(parts)
    env.request_headers[Faraday::Env::ContentLength] = body.length.to_s
    body
  end
end

class SalesforceFileUploadError < StandardError; end

class ApplicationAttachmentsToSalesforceJob < ApplicationJob
  queue_as :default
  SALESFORCE_API_VERSION = "47.0".freeze

  # Implements API https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_sobject_insert_update_blob.htm#inserting_a_contentversion
  # @param salesforce_case_id [string]
  # @param record [ActiveRecord]
  # @param attachment_field [Symbol]
  # @param description [String] file description
  # @param attachment_index [Integer] index of file attachment when attachment_field
  #                                   refers to a collection of files
  def perform(salesforce_case_id, record, attachment_field, description, attachment_index = nil)
    client = Restforce.new(
      username: Rails.configuration.x.salesforce.username,
      password: Rails.configuration.x.salesforce.password,
      security_token: Rails.configuration.x.salesforce.security_token,
      client_id: Rails.configuration.x.salesforce.client_id,
      client_secret: Rails.configuration.x.salesforce.client_secret,
      host: Rails.configuration.x.salesforce.host,
      api_version: SALESFORCE_API_VERSION
    )

    # If an attachment_index parameter is found, then we should perform
    # record.send on the element within the array, else simply perform
    # record.send on the passed in attachment_field
    file = if attachment_index
             record.send(attachment_field)[attachment_index]
    else
      record.send(attachment_field)
    end

    filename = file.filename.to_s
    path = "/services/data/v#{SALESFORCE_API_VERSION}/sobjects/ContentVersion"
    json = {FirstPublishLocationId: salesforce_case_id, ReasonForChange: "Uploading attachment #{filename}", PathOnClient: filename, Description: description}.to_json
    auth = client.authenticate!
    url = auth.instance_url + path
    conn = Faraday.new(url) { |c|
      c.request :multipart
      c.request :json
      c.adapter :net_http
    }

    file.open do |f|
      payload = {
        entity_content: json,
        VersionData: Restforce::UploadIO.new(f.path, file.content_type)
      }
      @response = conn.post(url, payload, {"Authorization" => "Bearer #{auth.access_token}"})
    end
    raise SalesforceFileUploadError.new("File upload failed for file #{filename} on Salesforce Case ID #{salesforce_case_id} with error #{@response.body}") unless @response.status == 201
    logger.info("Successfully uploaded file #{filename} on Salesforce Case ID #{salesforce_case_id}")
  end
end
