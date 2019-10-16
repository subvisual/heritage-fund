require 'restforce'
require "logger"
require "json"
require 'faraday'

class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]


  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

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
    		"organisationType": "not-for-profit-company",
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
    # response = client.post do |request|
    #   request.url '/services/apexrest/loadData'
    #   request.headers['Content-Type'] = 'application/json'
    #   request.body = payload
    # end
    # debugger
    
    # auth = client.authenticate!
    # resp = Faraday.post(auth.instance_url + '/services/apexrest/loadData', JSON.parse(payload).to_json,
    #   "Content-Type" => "application/json", "Authorization" => "Bearer #{auth.access_token}")
    # debugger
    
    @project = Project.new(project_params)
    @project.user = User.find_by(uid: session[:user_id])
    @payload_obj = JSON.parse(payload)
    @payload_obj['meta']['username'] = @project.user.email 
    @payload_obj['application']['projectName'] = @project.project_title
    @payload_obj['application']['organisationName'] = @project.user.organisation.name
    @payload_obj['application']['organisationId'] = @project.user.organisation.id

    @response = client.post('/services/apexrest/loadData', @payload_obj.to_json,  {'Content-Type'=>'application/json'})
    puts("Salesforce case id is #{JSON.parse(@response.body)['caseId']}")

    respond_to do |format|
      if @project.save
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

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
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
