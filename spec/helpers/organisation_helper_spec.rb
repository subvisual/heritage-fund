require 'rails_helper'

RSpec.describe OrganisationHelper do

  describe '#complete_organisation_details' do
    
    let (:legal_signatory) {
      create(
        :legal_signatory,
        id: '1',
        name: 'Joe Bloggs',
        email_address: 'joe@bloggs.com',
        phone_number: '07000000000'
      )
    }

    let (:organisation) {
      create(
        :organisation,
        id: '1',
        name: 'Test Organisation',
        line1: '10 Downing Street',
        line2: 'Westminster',
        townCity: 'London',
        county: 'London',
        postcode: 'SW1A 2AA',
        org_type: 1
      )
    }
  
    it 'should return true if all mandatory organisation details are present' do
    
      organisation.legal_signatories.append(legal_signatory)  
  
      expect(complete_organisation_details?(organisation)).to eq(true) 
            
    end

    it 'should return false if a mandatory organisation detail is not present' do
      
      organisation.legal_signatories.append(legal_signatory)  

      organisation.name = nil
  
      expect(complete_organisation_details?(organisation)).to eq(false) 
              
    end

    it 'should return false if no legal signatories are present' do
       
      expect(complete_organisation_details?(organisation)).to eq(false)  
      
    end

  end

end
