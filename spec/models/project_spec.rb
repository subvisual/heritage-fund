require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'Project model' do
    it 'should serialise Salesforce JSON successfully' do
      @project = build(
        :project,
        id: '2c660111-ab15-4221-98e0-cf0e02748a9b',
        project_title: 'Test Project', start_date: '1/1/2025',
        end_date: '1/10/2025', line1: '10 Downing Street',
        line2: 'Westminster', townCity: 'London', county: 'LONDON',
        postcode: 'SW1A 2AA', description: 'A description of my project...',
        difference: 'The difference my project will make to...',
        matter: 'My project matters because...',
        best_placed_description: 'My organisation is best placed to...',
        heritage_description: 'The heritage of my project...',
        involvement_description: 'My project will involve a wider range of ' \
                                 'people...',
        outcome_2: true, outcome_3: false, outcome_4: true, outcome_5: false,
        outcome_6: true, outcome_7: false, outcome_8: true, outcome_9: false,
        outcome_2_description: 'Description of outcome 2',
        outcome_3_description: '',
        outcome_4_description: 'Description of outcome 4',
        outcome_5_description: '',
        outcome_6_description: 'Description of outcome 6',
        outcome_7_description: '',
        outcome_8_description: 'Description of outcome 8',
        outcome_9_description: '', permission_type: 2,
        permission_description: 'permission description',
        partnership_details: 'partnership details',
        declaration_reasons_description: 'something'
      )

      organisation = build(
        :organisation,
        name: 'Test Organisation',
        org_type: 5,
        mission: %w[young-people-led disability-led],
        charity_number: '12345',
        company_number: '54321',
        line1: '10 Downing Street',
        line2: 'Westminster',
        townCity: 'London',
        county: 'LONDON',
        postcode: 'SW1A 2AA'
      )

      @project.user.organisations.append(organisation)

      legal_signatory_one = build(
        :legal_signatory,
        name: 'Joe Bloggs',
        email_address: @project.user.email,
        phone_number: '07123456789'
      )

      legal_signatory_two = build(
        :legal_signatory,
        name: 'Jane Bloggs',
        email_address: 'jane@bloggs.com',
        phone_number: '07987654321'
      )

      organisation.legal_signatories.append(
        legal_signatory_one,
        legal_signatory_two
      )

      project_salesforce_json = JSON.parse(@project.to_salesforce_json)

      # Assert metadata parameters
      expect(project_salesforce_json['meta']['applicationId'])
        .to eq('2c660111-ab15-4221-98e0-cf0e02748a9b')
      expect(project_salesforce_json['meta']['username'])
        .to eq(@project.user.email)

      expect(project_salesforce_json['application'].with_indifferent_access).to include(
        {
          mainContactName: 'Joe Bloggs',
          mainContactDateOfBirth: '1980-01-01',
          mainContactPhone: '07123456789',
          mainContactEmail: @project.user.email,
          mainContactAddress: hash_including({
                                               'line1' => '10 Downing Street, Westminster',
                                               'townCity' => 'London',
                                               'county' => 'LONDON',
                                               'postcode' => 'SW1A 2AA'
                                             }),
          organisationName: 'Test Organisation',
          organisationType: 'faith-based-or-church-organisation',
          charityNumber: '12345',
          companyNumber: '54321',
          organisationAddress: hash_including({
                                                'line1' => '10 Downing Street, Westminster',
                                                'townCity' => 'London',
                                                'county' => 'LONDON',
                                                'postcode' => 'SW1A 2AA'
                                              }),
          authorisedSignatoryOneDetails: hash_including({
                                                          name: 'Joe Bloggs',
                                                          email: @project.user.email,
                                                          isAlsoApplicant: true,
                                                          phone: '07123456789'
                                                        }),
          authorisedSignatoryTwoDetails: hash_including({
                                                          name: 'Jane Bloggs',
                                                          email: 'jane@bloggs.com',
                                                          isAlsoApplicant: false,
                                                          phone: '07987654321'
                                                        }),
          projectName: 'Test Project',
          projectDateRange: { startDate: '2025-01-01', endDate: '2025-10-01' },
          projectAddress: hash_including({
                                           line1: '10 Downing Street, Westminster',
                                           townCity: 'London',
                                           county: 'LONDON',
                                           projectPostcode: 'SW1A 2AA'
                                         }),
          yourIdeaProject: 'A description of my project...',
          projectDifference: 'The difference my project will make to...',
          projectOrgBestPlace: 'My organisation is best placed to...',
          projectAvailable: 'The heritage of my project...',
          projectOutcome1: 'My project will involve a wider range of people...',
          projectOutcome2: 'Description of outcome 2',
          projectOutcome3: '',
          projectOutcome4: 'Description of outcome 4',
          projectOutcome5: '',
          projectOutcome6: 'Description of outcome 6',
          projectOutcome7: '',
          projectOutcome8: 'Description of outcome 8',
          projectOutcome9: '',
          projectOutcome2Checked: true,
          projectOutcome3Checked: false,
          projectOutcome4Checked: true,
          projectOutcome5Checked: false,
          projectOutcome6Checked: true,
          projectOutcome7Checked: false,
          projectOutcome8Checked: true,
          projectOutcome9Checked: false,
          projectNeedsPermission: 'not-sure',
          projectNeedsPermissionDetails: 'permission description',
          partnershipDetails: 'partnership details',
          informationNotPubliclyAvailableRequest: 'something'
        }
      )
    end
  end
end
