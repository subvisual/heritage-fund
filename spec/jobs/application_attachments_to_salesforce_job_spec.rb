require "rails_helper"

RSpec.describe ApplicationAttachmentsToSalesforceJob, type: :job do
  let(:project_with_attachment) {
    project = create(:project)
    project.capital_work_file.attach(io: File.open(Rails.root.join("spec/fixtures/files/example.txt")), filename: "example.txt", content_type: "text/plain")
    project
  }

  let(:request_headers) {
    {
      "Authorization" => "Bearer",
      "Content-Type" => /multipart\/form-data; boundary=-----------RubyMultipartPost-[a-f0-9]+/
    }
  }

  let(:request_url) {
    "https://example.salesforce.com/services/data/v47.0/sobjects/ContentVersion"
  }

  before(:each) do
    stub_request(:post, "https://test.salesforce.com/services/oauth2/token").to_return(status: 200,
                                                                                       body:
        '{"instance_url":"https://example.salesforce.com"}')
  end

  it "throws exception given error response from Salesforce" do
    @error_body = '{
    "fields" : [ "FolderId" ],
    "message" : "Folder ID: id value of incorrect type: 005D0000001GiU7",
    "errorCode" : "MALFORMED_ID"
}'
    stub_request(:post, request_url)
      .with(
        headers: request_headers
      )
      .to_return(status: 400, body: @error_body, headers: {})
    expect { ApplicationAttachmentsToSalesforceJob.perform_now("NS-XXX", project_with_attachment, :capital_work_file, "description") }.to raise_error(SalesforceFileUploadError, "File upload failed for file example.txt on Salesforce Case ID NS-XXX with error " + @error_body)
  end

  it "succeeds given success response from Salesforce" do
    stub_request(:post, request_url)
      .with(
        headers: request_headers
      )
      .to_return(status: 201,
                 body: '{
    "id" : "068D00000000pgOIAQ",
    "errors" : [ ],
    "success" : true
}')
    allow(Rails.logger).to receive(:info)
    expect(Rails.logger).to receive(:info).with("Successfully uploaded file example.txt on Salesforce Case ID NS-XXX")
    expect { ApplicationAttachmentsToSalesforceJob.perform_now("NS-XXX", project_with_attachment, :capital_work_file, "description") }.not_to raise_exception
  end

  it "succeeds with multiple files given success response from Salesforce" do
    stub_request(:post, request_url)
      .with(
        headers: request_headers
      )
      .to_return(status: 201,
                 body: '{
    "id" : "068D00000000pgOIAQ",
    "errors" : [ ],
    "success" : true
}')

    project_with_multiple_attachments = create(:project)
    project_with_multiple_attachments.accounts_files.attach(
      [
        io: File.open(Rails.root.join("spec/fixtures/files/example.txt")),
        filename: "example.txt",
        content_type: "text/plain"
      ],
      [
        io: File.open(Rails.root.join("spec/fixtures/files/example.txt")),
        filename: "example.txt",
        content_type: "text/plain"
      ]
    )

    allow(Rails.logger).to receive(:info)
    expect(Rails.logger).to receive(:info).with("Successfully uploaded file example.txt on Salesforce Case ID NS-XXX")
    expect { ApplicationAttachmentsToSalesforceJob.perform_now("NS-XXX", project_with_multiple_attachments, :accounts_files, "description", 0) }.not_to raise_exception
  end
end
