require 'restforce'
require "logger"
require "json"
require 'faraday'

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create

    payload = <<~HEREDOC 
    {
    	"meta": {
    		"form": "3-10k-grant",
    		"schemaVersion": "v1.x",
    		"environment": "production",
    		"commitId": "b4ecf18eae01d34b296e9388f387cc42bf7c0f93",
    		"locale": "en",
    		"username": "example@example.com",
    		"applicationId": "a9bffed0-e131-11e9-880f-31a49a4bf599",
    		"startedAt": "2019-05-17T15:34:13.000Z"
    	},
    	"application": {
    		"projectName": "ruby",
    		"projectDateRange": {
    			"startDate": "2020-12-12",
    			"endDate": "2020-12-12"
    		},
    		"projectAddress": {
    			"projectPostcode": "B15 1TR",
    			"line1": "82553 Demarco Rapid",
    			"townCity": "Waelchitown",
    			"county": "Berkshire"
    		},
    		"yourIdeaProject": "Free text…",
    		"projecDifference": "More free text",
    		"projectCommunity": "Even more free text",
    		"projectOrgBestPlace": "Even more and more free text",
    		"projectAvailable": "Even more more more text",
    		"projectOutcome1": "More and more and more free text",
    		"projectOutcome2": "More and more and more free text",
    		"projectOutcome3": "More and more and more free text",
    		"projectOutcome4": "More and more and more free text",
    		"projectOutcome5": "More and more and more free text",
    		"projectOutcome6": "More and more and more free text",
    		"projectOutcome7": "More and more and more free text",
    		"projectOutcome8": "More and more and more free text",
    		"projectOutcome9": null,
    		"projectTotalCosts": 20000,
    		"organisationId": "c23e12e0-e69e-11e9-aaf2-2514879727cc",
    		"organisationName": "ruby org",
    		"organisationAddress": {
    			"line1": "82553 Demarco Rapid",
    			"townCity": "Waelchitown",
    			"county": "Berkshire",
    			"postcode": "B15 1TR"
    		},
    		"organisationType": "local-authority",
    		"companyNumber": "123456789",
    		"charityNumber": null,
    		"charityNumberNi": null,
    		"mainContactName": "Nelda",
    		"mainContactDateOfBirth": "1975-10-12",
    		"mainContactAddress": {
    			"line1": "41465 Bashirian Oval",
    			"townCity": "Friesenhaven",
    			"county": "Berkshire",
    			"postcode": "B15 1TR"
    		},
    		"mainContactEmail": "Lizzie90@example.com",
    		"mainContactPhone": "0345 4 10 20 30",
    		"authorisedSignatoryRole": "trustee",
    		"authorisedSignatoryName": "Jane Doe",
    		"authorisedSignatoryPhone": "07777 777777",
    		"authorisedSignatoryEmail": "jane@example.com"
    	}
    }
    HEREDOC

    client = Restforce.new(username: ENV['SALESFORCE_USERNAME'], password: ENV['SALESFORCE_PASSWORD'], security_token: ENV['SALESFORCE_SECURITY_TOKEN'], client_id: ENV['SALESFORCE_CLIENT_ID'], client_secret: ENV['SALESFORCE_CLIENT_SECRET'],  host: 'test.salesforce.com')
    
    @project = Project.new(project_params)
    @project.user = current_user
    
    respond_to do |format|
      if @project.save
        @payload_obj = JSON.parse(payload)
        @payload_obj['meta']['username'] = @project.user.email 
        @payload_obj['meta']['applicationId'] = @project.id
        @payload_obj['application']['projectName'] = @project.project_title
        @payload_obj['application']['organisationName'] = @project.user.organisation.name
        @payload_obj['application']['organisationId'] = @project.user.organisation.id
    
        @response = client.post('/services/apexrest/PortalData', @payload_obj.to_json,  {'Content-Type'=>'application/json'})
        puts("Salesforce response: #{@response.body}")
        puts("Salesforce case id is #{JSON.parse(@response.body)['caseId']}")
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:project_title)
    end
end
