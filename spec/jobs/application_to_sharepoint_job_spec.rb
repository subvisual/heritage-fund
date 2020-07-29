require 'rails_helper'

RSpec.describe ApplicationToSharepointJob do
  let(:job) { ApplicationToSharepointJob.new }
  let(:funding_application) { build(:funding_application) }

  it 'should raise a MicrosoftSharePointError if the call to ' \
     'create_sharepoint_list item returns a non-HTTP 201 response ' \
     'when calling the perform method' do

      expect(funding_application).to receive(:update)
      expect(funding_application).to receive(
        :gp_hef_loan_to_sharepoint_json
      ).once.with(no_args).and_return('json_payload')

      expect(job).to receive(
        :create_new_sharepoint_list_item
      ).once.with('json_payload').and_return(
        FakeObjects::FakeHttpResponse.new(400, 'response_body')
      )

      expect{job.perform(funding_application)}.to raise_exception(
        ApplicationToSharepointJob::MicrosoftSharePointError, 
        'Received HTTP status code 400 when creating new Microsoft ' \
        'SharePoint list item. Response body received: response_body'
      )

  end

  it 'should not raise a MicrosoftSharePointError if the call to ' \
     'create_sharepoint_list item returns a HTTP 201 response ' \
     'when calling the perform method' do

    fake_notify_mailer = FakeObjects::FakeNotifyMailer.new

    expect(funding_application).to receive(:update)
    expect(funding_application).to receive(
      :gp_hef_loan_to_sharepoint_json
    ).once.with(no_args).and_return('json_payload')

    expect(job).to receive(
      :create_new_sharepoint_list_item
    ).once.with('json_payload').and_return(
      FakeObjects::FakeHttpResponse.new(201, {"d": {"ID": 1}}.to_json)
    )

    expect(job).to receive(
      :attach_files_to_sharepoint_list_item
    ).once.with(funding_application, 1)

    expect(NotifyMailer).to receive(
      :loan_application_submission_confirmation
    ).with(funding_application).and_return(fake_notify_mailer)
    expect(fake_notify_mailer).to receive(:deliver_later).once.with(no_args)

    job.perform(funding_application)

  end

  it 'should return the correct response when calling ' \
     'get_authentication_token_form_data' do

    response = job.get_authentication_token_form_data()

    expect(response).to eq(
      {
        client_id: 'app_reg_client_id@realm',
        client_secret: 'app_reg_client_secret',
        grant_type: 'client_credentials',
        resource: 'principal/test.sharepoint.com@realm'
      }
    )

  end

  it 'should return a valid response when the call to ' \
     'get_authentication_token returns a HTTP 200 response' do

    stub_request(
      :post,
      'https://accounts.accesscontrol.windows.net/realm/tokens/OAuth/2'
    ).to_return(
        status: 200,
        body: '{"access_token": "access token value"}'
    )

    response = job.get_authentication_token()

    expect(response).to eq('access token value')

    assert_requested(
      :post,
      'https://accounts.accesscontrol.windows.net/realm/tokens/OAuth/2',
      times: 1
    ) { |req|
        req.headers['Content_Type'] = 'application/x-www-form-urlencoded'
        req.body == URI.encode_www_form(
          {
            grant_type: 'client_credentials',
            client_id: 'app_reg_client_id@realm',
            client_secret: 'app_reg_client_secret',
            resource: 'principal/test.sharepoint.com@realm'
          }
        ) 
    }

  end

  it 'should return an invalid response when the call to ' \
     'get_authentication_token returns a non-HTTP 200 response' do

    stub_request(
      :post,
      'https://accounts.accesscontrol.windows.net/realm/tokens/OAuth/2'
    ).to_return(
        status: 400,
        body: 'test error string'
    )

    expect{ job.get_authentication_token() }
      .to raise_exception(
        ApplicationToSharepointJob::MicrosoftAuthenticationError,
        'Received HTTP status code 400 when retrieving authentication token. ' \
        'Response body received: test error string'
      )

    assert_requested(
      :post,
      'https://accounts.accesscontrol.windows.net/realm/tokens/OAuth/2',
      times: 1
    ) { |req|
        req.headers['Content_Type'] = 'application/x-www-form-urlencoded'
        req.body == URI.encode_www_form(
          {
            grant_type: 'client_credentials',
            client_id: 'app_reg_client_id@realm',
            client_secret: 'app_reg_client_secret',
            resource: 'principal/test.sharepoint.com@realm'
          }
        ) 
    }

  end

  it 'should return a valid response when the call to ' \
     'create_new_sharepoint_list_item returns a HTTP 200 response' do
      
    stub_request(
        :post,
        "https://test.sharepoint.com/sites/site_name/_api/web/lists(guid'list_id')/items"
      ).to_return(
          status: 200,
          body: 'a response'
      )

      allow(job).to receive(:get_authentication_token).with(no_args) { 'authentication_token' }

      response = job.create_new_sharepoint_list_item('json_payload')

      assert_requested(
        :post,
        "https://test.sharepoint.com/sites/site_name/_api/web/lists(guid'list_id')/items",
        body: 'json_payload',
        times: 1
      ) { |req| 
          req.headers['Authorization'] = 'Bearer authentication_token'
          req.headers['Accept'] = 'application/json;odata=verbose'
          req.headers['Content-Type'] = 'application/json;odata=verbose'
      }

  end

  it 'should return a valid response when the call to ' \
     'attach_files_to_sharepoint_list_item returns a HTTP 200 response' do

      allow(
        funding_application.gp_hef_loan
      ).to receive(:supporting_documents_files).and_return(['1', '2'])

      fake_response = FakeObjects::FakeHttpResponse.new(200, 'response_body')

      expect(job).to receive(
        :attach_file_to_sharepoint_list_item
      ).once.with(1, '1').and_return(fake_response)

      expect(job).to receive(
        :attach_file_to_sharepoint_list_item
      ).once.with(1, '2').and_return(fake_response)

      expect(job).to receive(:attach_file_to_sharepoint_list_item).at_most(2).times

      expect { 
        job.attach_files_to_sharepoint_list_item(funding_application, 1) 
      }.not_to(raise_error)

  end

  it 'should return an invalid response when the call to ' \
     'attach_files_to_sharepoint_list_item returns a HTTP 400 response' do

    allow(
      funding_application.gp_hef_loan
    ).to receive(:supporting_documents_files).and_return(['1', '1'])

    expect(job).to receive(
      :attach_file_to_sharepoint_list_item
    ).once.with(1, '1').and_return(
      FakeObjects::FakeHttpResponse.new(400, 'test error string')
    )

    expect(job).to receive(:attach_file_to_sharepoint_list_item).at_most(:once)

    expect{ job.attach_files_to_sharepoint_list_item(funding_application, 1) }
    .to raise_exception(
      ApplicationToSharepointJob::MicrosoftSharePointError,
      'Received HTTP status code 400 when attaching file to ' \
      'Microsoft SharePoint list item ID: 1. ' \
      'Response body received: test error string'
    )

  end

  it 'should return an valid response when the call to ' \
  'attach_file_to_sharepoint_list_item returns a HTTP 200 response' do

    fake_file = FakeObjects::FakeFile.new

    allow(job).to receive(:get_authentication_token).with(no_args) { 'authentication_token' }
    allow(job).to receive(:read_file_from_activestorage_blob)
      .with(fake_file).and_return('file_data')

    stub_request(
      :post,
      "https://test.sharepoint.com/sites/site_name/_api/web/lists(guid'list_id')" \
        "/items(1)/AttachmentFiles/add(FileName='filename.txt')"
    ).with(
      body: 'file_data'
    ).to_return(
        status: 200,
        body: 'a response'
    )

    response = job.attach_file_to_sharepoint_list_item(1, fake_file)

    assert_requested(
      :post,
      "https://test.sharepoint.com/sites/site_name/_api/web/lists(guid'list_id')" \
        "/items(1)/AttachmentFiles/add(FileName='filename.txt')",
      times: 1
    ) { |req| 
        req.headers['Authorization'] = 'Bearer authentication_token'
    }

  end

end
