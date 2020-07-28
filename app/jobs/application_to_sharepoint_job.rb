require 'faraday'
require 'json'
require 'uri'

class ApplicationToSharepointJob < ApplicationJob

  class MicrosoftAuthenticationError < StandardError; end
  class MicrosoftSharePointError < StandardError; end

  queue_as :default

  # @param [FundingApplication] funding_application
  #
  # Method to create new SharePoint list items for a submitted FundingApplication
  # This is done using the legacy Microsoft SharePoint REST API, as the Microsoft
  # Graph API (which replaces the deprecated API) is unable to handle attachments
  # to SharePoint list items at the time of development.
  #
  # This method will submit a POST request to the API to create a new list item
  # and then submit further POST requests for each supporting document that it
  # needs to add to the list item.
  def perform(funding_application)

    logger.info "Submitting funding application (ID: #{funding_application.id}) to Microsoft SharePoint"

    # Mark the application as being submitted by updating the submitted_on attribute
    funding_application.update(submitted_on: DateTime.now)

    new_item_payload = funding_application.gp_hef_loan_to_sharepoint_json

    response = create_new_sharepoint_list_item(new_item_payload)

    unless response.status == 201
      raise MicrosoftSharePointError.new(
        "Received HTTP status code #{response.status} when creating new Microsoft SharePoint list item. " \
        "Response body received: #{response.body}"
      )
    end

    # Parse the response body as JSON so that we can access the ID necessary
    # to attach files to the list item
    json_response = JSON.parse(response.body)
    
    # Retrieve the ID from the JSONified response body
    sharepoint_list_item_id = json_response['d']['ID']

    attach_files_to_sharepoint_list_item(funding_application, sharepoint_list_item_id)

    # Send an email from Notify to the applicant
    NotifyMailer.loan_application_submission_confirmation(funding_application).deliver_later

    logger.info(
      "Completed submission of funding application (ID: #{funding_application.id} " \
      'to Microsoft SharePoint successfully'
    )

  end

  private

  # Method to retrieve the authentication token necessary for authenticating
  # requests to the Microsoft SharePoint REST API
  def get_authentication_token()

    logger.info "Retrieving authentication token for Microsoft integration"

    get_authentication_token_uri = URI(
      "https://accounts.accesscontrol.windows.net/#{Rails.configuration.x.sharepoint.realm}/tokens/OAuth/2"
    )

    response = Faraday.post(get_authentication_token_uri) do |request|

      request.headers['Content_Type'] = 'application/x-www-form-urlencoded'
      request.body = URI.encode_www_form(get_authentication_token_form_data())

    end

    if response.status == 200

      json_response = JSON.parse(response.body)

      return json_response['access_token']

    else

      raise MicrosoftAuthentication.new(
        "Received HTTP status code #{response.status} when retrieving authentication token. " \
        "Response body received: #{response.body}"
      )

    end

  end

  # Method to construct the necessary form data to pass into the request
  # to retrieve an authentication token
  def get_authentication_token_form_data()

    form_data = {
      grant_type: 'client_credentials',
      client_id: "#{Rails.configuration.x.sharepoint.app_reg_client_id}@" \
                  "#{Rails.configuration.x.sharepoint.realm}",
      client_secret: "#{Rails.configuration.x.sharepoint.app_reg_client_secret}",
      resource: "#{Rails.configuration.x.sharepoint.principal}/" \
                "#{Rails.configuration.x.sharepoint.target_host}@" \
                "#{Rails.configuration.x.sharepoint.realm}"
    }

  end

  # Method to create a new Microsoft SharePoint list item based on
  # the json_payload argument passed
  #
  # @param [JSON] json_payload A JSON representation of 
  def create_new_sharepoint_list_item(json_payload)

    authentication_token = get_authentication_token()

    create_new_list_item_uri = URI(
      "https://#{Rails.configuration.x.sharepoint.target_host}/sites/" \
      "#{Rails.configuration.x.sharepoint.site_name}/_api/web/lists" \
      "(guid'#{Rails.configuration.x.sharepoint.list_id}')/items"
    )

    logger.info "Creating new Microsoft SharePoint list item"

    response = Faraday.post(create_new_list_item_uri, json_payload) do |request|

      request.headers['Authorization'] = "Bearer #{authentication_token}"
      request.headers['Accept'] = 'application/json;odata=verbose'
      request.headers['Content-Type'] = 'application/json;odata=verbose'

    end

  end

  # Method to add multiple files to a SharePoint list item - iterates over
  # each supporting document attached to a given funding application and then
  # calls the attach_file_to_sharepoint_list_item for each supporting document
  # found
  #
  # @param [FundingApplication] funding_application An instance of FundingApplication
  # @param [int] list_item_id                       The unique identifier of a Microsoft
  #                                                 SharePoint list item
  def attach_files_to_sharepoint_list_item(funding_application, list_item_id)

    funding_application.gp_hef_loan.supporting_documents_files.each do |sd|

      response = attach_file_to_sharepoint_list_item(list_item_id, sd)

      unless response.status == 200
        raise MicrosoftSharePointError.new(
          "Received HTTP status code #{response.status} when attaching file to " \
          "Microsoft SharePoint list item ID: #{list_item_id}. Response body " \
          "received: #{response.body}"
        )
      end

    end

  end

  # Method to add an individual file to a SharePoint list item
  #
  # @param [int] list_item_id   The unique identifier of a Microsoft
  #                             SharePoint list item
  # @param [ActiveStorage] file A given ActiveStorage attachment
  def attach_file_to_sharepoint_list_item(list_item_id, file)

    authentication_token = get_authentication_token()

    # URI escape the filename in order for the URI method to parse
    # the specified URI correctly
    url_escaped_filename = URI.escape(file.blob.filename.to_s)

    attach_file_to_list_item_uri = URI(
      "https://#{Rails.configuration.x.sharepoint.target_host}/sites/" \
      "#{Rails.configuration.x.sharepoint.site_name}/_api/web/lists" \
      "(guid'#{Rails.configuration.x.sharepoint.list_id}')/items(" \
      "#{list_item_id})/AttachmentFiles/add(FileName='#{url_escaped_filename}')"
    )

    logger.info "Attaching file to Microsoft SharePoint list item ID: #{list_item_id}"

    conn = Faraday.new(url: attach_file_to_list_item_uri) do |c|
      c.authorization :Bearer, authentication_token
      c.adapter :net_http
    end

    # Read the file so that we can pass it into the subsequent POST request
    data = File.read(ActiveStorage::Blob.service.path_for(file.blob.key))

    response = conn.post(attach_file_to_list_item_uri, data) do |request|
        request.headers['Authorization'] = "Bearer #{authentication_token}"

    end

  end

end
