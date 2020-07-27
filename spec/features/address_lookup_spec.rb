require 'rails_helper'

RSpec.feature 'Application', type: :feature do
  before(:each) do
    ideal_postcode_stub_requests
  end
  scenario 'Address Lookup' do

    person = FactoryBot.create(:person)
    organisation = FactoryBot.create(:organisation)

    user = FactoryBot.create(
      :user,
      name: 'Jane Doe',
      phone_number: '123',
      email: 'test@test.com',
      date_of_birth: Date.new,
      person_id: person.id,
      organisation_id: organisation.id
  )

    login_as(user, :scope => :user)
    visit "/user/#{organisation.id}/address/postcode"
    expect(page).to have_text 'Find your address'
    fill_in('Postcode', with: 'ID1 1QD')
    click_button 'Find address'
    expect(page)
        .to have_current_path("/user/#{organisation.id}/address/address-results?locale=en-GB")
    select('4 Barons Court Road', from: 'address')
    click_button 'Select'
    expect(page)
        .to have_current_path("/user/#{organisation.id}/address/address-details?locale=en-GB")
    expect(page).to have_field('Address line 1', with: '4 Barons Court Road')
    expect(page).to have_field('Town', with: 'LONDON')
    expect(page).to have_field('County', with: 'London')
    expect(page).to have_field('Postcode', with: 'W14 9DT')
    click_button 'Save and continue'
    user_record = User.find(user.id)
    expect(user_record.line1).to eq('4 Barons Court Road')
    expect(user_record.townCity).to eq('LONDON')
    expect(user_record.county).to eq('London')
    expect(user_record.postcode).to eq('W14 9DT')

  end
end