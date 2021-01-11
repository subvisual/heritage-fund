module FeatureHelpers
  def ideal_postcode_stub_requests
    stub_request(:get, 'https://api.ideal-postcodes.co.uk/v1/postcodes/ID1%201QD?api_key=test')
      .with(
        headers: {
          'Host' => 'api.ideal-postcodes.co.uk'
        }
      )
      .to_return(
        status: 200,
        body: File.read(Rails.root.join('spec', 'fixtures', 'requests', 'postcodes-id1.json')),
        headers: {}
      )

    stub_request(:get, 'https://api.ideal-postcodes.co.uk/v1/addresses/25962215?api_key=test')
      .with(
        headers: {
          'Host' => 'api.ideal-postcodes.co.uk'
        }
      )
      .to_return(
        status: 200,
        body: File.read(Rails.root.join('spec', 'fixtures', 'requests', 'addresses_25962215.json')),
        headers: {}
      )
  end

  def set_address(title_field)
    ideal_postcode_stub_requests
    fill_in('postcode[lookup]', with: 'ID1 1QD')
    click_button 'Find address'
    select('4 Barons Court Road', from: 'address')
    click_button 'Select'
    fill_in(title_field, with: 'test')
    click_button 'Save and continue'
  end
end
