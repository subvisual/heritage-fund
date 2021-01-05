require "rails_helper"

RSpec.describe Project, type: :model do
  describe "Project model" do
    it "should serialise Salesforce JSON successfully" do
      @project = build(
        :project,
        id: "2c660111-ab15-4221-98e0-cf0e02748a9b",
        project_title: "Test Project",
        start_date: "1/1/2025",
        end_date: "1/10/2025",
        line1: "10 Downing Street",
        line2: "Westminster",
        townCity: "London",
        county: "LONDON",
        postcode: "SW1A 2AA",
        description: "A description of my project...",
        difference: "The difference my project will make to...",
        matter: "My project matters because...",
        best_placed_description: "My organisation is best placed to...",
        heritage_description: "The heritage of my project...",
        involvement_description: "My project will involve a wider range of " \
                                 "people...",
        outcome_2: true,
        outcome_3: false,
        outcome_4: true,
        outcome_5: false,
        outcome_6: true,
        outcome_7: false,
        outcome_8: true,
        outcome_9: false,
        outcome_2_description: "Description of outcome 2",
        outcome_3_description: "",
        outcome_4_description: "Description of outcome 4",
        outcome_5_description: "",
        outcome_6_description: "Description of outcome 6",
        outcome_7_description: "",
        outcome_8_description: "Description of outcome 8",
        outcome_9_description: "",
        permission_type: 2,
        permission_description: "permission description",
        partnership_details: "partnership details",
        declaration_reasons_description: "something"
      )

      organisation = build(
        :organisation,
        name: "Test Organisation",
        org_type: 5,
        mission: %w[young-people-led disability-led],
        charity_number: "12345",
        company_number: "54321",
        line1: "10 Downing Street",
        line2: "Westminster",
        townCity: "London",
        county: "LONDON",
        postcode: "SW1A 2AA"
      )

      @project.user.organisations.append(organisation)

      legal_signatory_one = build(
        :legal_signatory,
        name: "Joe Bloggs",
        email_address: @project.user.email,
        phone_number: "07123456789"
      )

      legal_signatory_two = build(
        :legal_signatory,
        name: "Jane Bloggs",
        email_address: "jane@bloggs.com",
        phone_number: "07987654321"
      )

      organisation.legal_signatories.append(
        legal_signatory_one,
        legal_signatory_two
      )

      project_salesforce_json = JSON.parse(@project.to_salesforce_json)

      # Assert metadata parameters
      expect(project_salesforce_json["meta"]["applicationId"])
        .to eq("2c660111-ab15-4221-98e0-cf0e02748a9b")
      expect(project_salesforce_json["meta"]["username"])
        .to eq(@project.user.email)

      # Assert main contact parameters
      expect(project_salesforce_json["application"]["mainContactName"])
        .to eq("Joe Bloggs")
      expect(project_salesforce_json["application"]["mainContactDateOfBirth"])
        .to eq("1980-01-01")
      expect(project_salesforce_json["application"]["mainContactPhone"])
        .to eq("07123456789")
      expect(project_salesforce_json["application"]["mainContactEmail"])
        .to eq(@project.user.email)
      expect(project_salesforce_json["application"]["mainContactAddress"]["line1"])
        .to eq("10 Downing Street, Westminster")
      expect(project_salesforce_json["application"]["mainContactAddress"]["townCity"])
        .to eq("London")
      expect(project_salesforce_json["application"]["mainContactAddress"]["county"])
        .to eq("LONDON")
      expect(project_salesforce_json["application"]["mainContactAddress"]["postcode"])
        .to eq("SW1A 2AA")

      # Assert organisation parameters
      expect(project_salesforce_json["application"]["organisationName"])
        .to eq("Test Organisation")
      expect(project_salesforce_json["application"]["organisationType"])
        .to eq("faith-based-or-church-organisation")
      expect(project_salesforce_json["application"]["organisationMission"])
        .to eq(%w[young-people-led disability-led])
      expect(project_salesforce_json["application"]["charityNumber"])
        .to eq("12345")
      expect(project_salesforce_json["application"]["companyNumber"])
        .to eq("54321")
      expect(project_salesforce_json["application"]["organisationAddress"]["line1"])
        .to eq("10 Downing Street, Westminster")
      expect(project_salesforce_json["application"]["organisationAddress"]["townCity"])
        .to eq("London")
      expect(project_salesforce_json["application"]["organisationAddress"]["county"])
        .to eq("LONDON")
      expect(project_salesforce_json["application"]["organisationAddress"]["postcode"])
        .to eq("SW1A 2AA")

      # Assert legal signatory parameters
      expect(project_salesforce_json["application"]["authorisedSignatoryOneDetails"]["name"])
        .to eq("Joe Bloggs")
      expect(project_salesforce_json["application"]["authorisedSignatoryOneDetails"]["email"])
        .to eq(@project.user.email)
      expect(project_salesforce_json["application"]["authorisedSignatoryOneDetails"]["isAlsoApplicant"])
        .to eq(true)
      expect(project_salesforce_json["application"]["authorisedSignatoryOneDetails"]["phone"])
        .to eq("07123456789")
      expect(project_salesforce_json["application"]["authorisedSignatoryTwoDetails"]["name"])
        .to eq("Jane Bloggs")
      expect(project_salesforce_json["application"]["authorisedSignatoryTwoDetails"]["email"])
        .to eq("jane@bloggs.com")
      expect(project_salesforce_json["application"]["authorisedSignatoryTwoDetails"]["isAlsoApplicant"])
        .to eq(false)
      expect(project_salesforce_json["application"]["authorisedSignatoryTwoDetails"]["phone"])
        .to eq("07987654321")

      # Assert project parameters
      expect(project_salesforce_json["application"]["projectName"])
        .to eq("Test Project")
      expect(project_salesforce_json["application"]["projectDateRange"]["startDate"])
        .to eq("2025-01-01")
      expect(project_salesforce_json["application"]["projectDateRange"]["endDate"])
        .to eq("2025-10-01")
      expect(project_salesforce_json["application"]["projectAddress"]["line1"])
        .to eq("10 Downing Street, Westminster")
      expect(project_salesforce_json["application"]["projectAddress"]["townCity"])
        .to eq("London")
      expect(project_salesforce_json["application"]["projectAddress"]["county"])
        .to eq("LONDON")
      expect(project_salesforce_json["application"]["projectAddress"]["projectPostcode"])
        .to eq("SW1A 2AA")
      expect(project_salesforce_json["application"]["yourIdeaProject"])
        .to eq("A description of my project...")
      expect(project_salesforce_json["application"]["projectDifference"])
        .to eq("The difference my project will make to...")
      expect(project_salesforce_json["application"]["projectOrgBestPlace"])
        .to eq("My organisation is best placed to...")
      expect(project_salesforce_json["application"]["projectAvailable"])
        .to eq("The heritage of my project...")
      expect(project_salesforce_json["application"]["projectOutcome1"])
        .to eq("My project will involve a wider range of people...")
      expect(project_salesforce_json["application"]["projectOutcome2"])
        .to eq("Description of outcome 2")
      expect(project_salesforce_json["application"]["projectOutcome3"])
        .to eq("")
      expect(project_salesforce_json["application"]["projectOutcome4"])
        .to eq("Description of outcome 4")
      expect(project_salesforce_json["application"]["projectOutcome5"])
        .to eq("")
      expect(project_salesforce_json["application"]["projectOutcome6"])
        .to eq("Description of outcome 6")
      expect(project_salesforce_json["application"]["projectOutcome7"])
        .to eq("")
      expect(project_salesforce_json["application"]["projectOutcome8"])
        .to eq("Description of outcome 8")
      expect(project_salesforce_json["application"]["projectOutcome9"])
        .to eq("")
      expect(project_salesforce_json["application"]["projectOutcome2Checked"])
        .to eq(true)
      expect(project_salesforce_json["application"]["projectOutcome3Checked"])
        .to eq(false)
      expect(project_salesforce_json["application"]["projectOutcome4Checked"])
        .to eq(true)
      expect(project_salesforce_json["application"]["projectOutcome5Checked"])
        .to eq(false)
      expect(project_salesforce_json["application"]["projectOutcome6Checked"])
        .to eq(true)
      expect(project_salesforce_json["application"]["projectOutcome7Checked"])
        .to eq(false)
      expect(project_salesforce_json["application"]["projectOutcome8Checked"])
        .to eq(true)
      expect(project_salesforce_json["application"]["projectOutcome9Checked"])
        .to eq(false)
      expect(project_salesforce_json["application"]["projectNeedsPermission"])
        .to eq("not-sure")
      expect(project_salesforce_json["application"]["projectNeedsPermissionDetails"])
        .to eq("permission description")
      expect(project_salesforce_json["application"]["partnershipDetails"])
        .to eq("partnership details")
      expect(project_salesforce_json["application"]["informationNotPubliclyAvailableRequest"])
        .to eq("something")
    end
  end
end
