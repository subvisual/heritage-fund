require 'rails_helper'

RSpec.feature 'Application', type: :feature do
  before(:each) do
    stub_request(:get, "https://api.ideal-postcodes.co.uk/v1/postcodes/ID1%201QD?api_key=test").
        with(
            headers: {
                'Host' => 'api.ideal-postcodes.co.uk',
            }).
        to_return(status: 200, body: '{"result":[{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"2","building_name":"","sub_building_name":"","po_box":"","department_name":"","organisation_name":"","udprn":25962203,"umprn":"","postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"1G","line_1":"2 Barons Court Road","line_2":"","line_3":"","premise":"2","country":"England","county":"Greater London","administrative_county":"","postal_county":"","traditional_county":"Greater London","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299},{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"2","building_name":"Basement Flat","sub_building_name":"","po_box":"","department_name":"","organisation_name":"","udprn":52618355,"umprn":"","postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"3A","line_1":"Basement Flat","line_2":"2 Barons Court Road","line_3":"","premise":"Basement Flat, 2","country":"England","county":"Greater London","administrative_county":"","postal_county":"","traditional_county":"Greater London","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299},{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"4","building_name":"","sub_building_name":"","po_box":"","department_name":"","organisation_name":"","udprn":25962215,"umprn":"","postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"1W","line_1":"4 Barons Court Road","line_2":"","line_3":"","premise":"4","country":"England","county":"Greater London","administrative_county":"","postal_county":"","traditional_county":"Greater London","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299},{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"4","building_name":"","sub_building_name":"Basement","po_box":"","department_name":"","organisation_name":"","udprn":25962189,"umprn":"","postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"2P","line_1":"Basement","line_2":"4 Barons Court Road","line_3":"","premise":"Basement, 4","country":"England","county":"Greater London","administrative_county":"","postal_county":"","traditional_county":"Greater London","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299},{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"6","building_name":"","sub_building_name":"","po_box":"","department_name":"","organisation_name":"","udprn":25962218,"umprn":"","postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"1Y","line_1":"6 Barons Court Road","line_2":"","line_3":"","premise":"6","country":"England","county":"Greater London","administrative_county":"","postal_county":"","traditional_county":"Greater London","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299},{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"8","building_name":"","sub_building_name":"","po_box":"","department_name":"","organisation_name":"","udprn":25962219,"umprn":"","postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"1Z","line_1":"8 Barons Court Road","line_2":"","line_3":"","premise":"8","country":"England","county":"Greater London","administrative_county":"","postal_county":"","traditional_county":"Greater London","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299},{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"59","building_name":"","sub_building_name":"","po_box":"","department_name":"","organisation_name":"ID Consulting Limited","udprn":25946509,"umprn":"","postcode_type":"S","su_organisation_indicator":"Y","delivery_point_suffix":"1N","line_1":"ID Consulting Limited","line_2":"59 Barons Court Road","line_3":"","premise":"59","country":"England","county":"Greater London","administrative_county":"","postal_county":"","traditional_county":"Greater London","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299}],"code":2000,"message":"Success"}', headers: {})

    stub_request(:get, "https://api.ideal-postcodes.co.uk/v1/addresses/25962215?api_key=test").
        with(
            headers: {
                'Host'=>'api.ideal-postcodes.co.uk',
            }).
        to_return(status: 200, body:'{"result":{"postcode":"W14 9DT","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"4","building_name":"","sub_building_name":"","po_box":"","department_name":"","organisation_name":"","udprn":25962215,"umprn":"","postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"1W","postcode_inward":"9DT","postcode_outward":"W14","line_1":"4 Barons Court Road","line_2":"","line_3":"","premise":"4","longitude":-0.208616,"latitude":51.489948,"eastings":524468,"northings":178299,"country":"England","traditional_county":"Greater London","administrative_county":"","postal_county":"London","county":"London","district":"Hammersmith and Fulham","ward":"North End"},"code":2000,"message":"Success"}' , headers: {})
  end
  scenario 'Address Lookup' do
    user = FactoryBot.create(:user, name: 'Jane Doe', phone_number: '123', date_of_birth: Date.new)
    login_as(user, :scope => :user)
    visit '/user/address'
    expect(page).to have_text 'Find your address'
    fill_in('Postcode', with: 'ID1 1QD')
    click_button 'Find address'
    expect(page).to have_current_path('/user/address/results')
    select('4 Barons Court Road', from: 'address')
    click_button 'Select'
    expect(page).to have_current_path('/user/address/show')
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