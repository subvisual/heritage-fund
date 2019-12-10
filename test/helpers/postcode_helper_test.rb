require 'test_helper'

class PostcodeHelperTest < ActiveSupport::TestCase
  include PostcodeHelper
  test "result formatter" do
    sample_result_line_1_only = {:postcode=>"ID1 1QD", :postcode_inward=>"1QD", :postcode_outward=>"ID1", :post_town=>"LONDON", :dependant_locality=>"", :double_dependant_locality=>"", :thoroughfare=>"Barons Court Road", :dependant_thoroughfare=>"", :building_number=>"2", :building_name=>"", :sub_building_name=>"", :po_box=>"", :department_name=>"", :organisation_name=>"", :udprn=>25962203, :umprn=>"", :postcode_type=>"S", :su_organisation_indicator=>"", :delivery_point_suffix=>"1G", :line_1=>"2 Barons Court Road", :line_2=>"", :line_3=>"", :premise=>"2", :country=>"England", :county=>"Greater London", :administrative_county=>"", :postal_county=>"", :traditional_county=>"Greater London", :district=>"Hammersmith and Fulham", :ward=>"North End", :longitude=>-0.208644362766368, :latitude=>51.4899488390558, :eastings=>524466, :northings=>178299}
    assert_equal(result_formatter(sample_result_line_1_only), ["2 Barons Court Road", 25962203])

    sample_result_line1_line2 = {:postcode=>"ID1 1QD", :postcode_inward=>"1QD", :postcode_outward=>"ID1", :post_town=>"LONDON", :dependant_locality=>"", :double_dependant_locality=>"", :thoroughfare=>"Barons Court Road", :dependant_thoroughfare=>"", :building_number=>"2", :building_name=>"Basement Flat", :sub_building_name=>"", :po_box=>"", :department_name=>"", :organisation_name=>"", :udprn=>52618355, :umprn=>"", :postcode_type=>"S", :su_organisation_indicator=>"", :delivery_point_suffix=>"3A", :line_1=>"Basement Flat", :line_2=>"2 Barons Court Road", :line_3=>"", :premise=>"Basement Flat, 2", :country=>"England", :county=>"Greater London", :administrative_county=>"", :postal_county=>"", :traditional_county=>"Greater London", :district=>"Hammersmith and Fulham", :ward=>"North End", :longitude=>-0.208644362766368, :latitude=>51.4899488390558, :eastings=>524466, :northings=>178299}
    assert_equal(result_formatter(sample_result_line1_line2), ["Basement Flat, 2 Barons Court Road", 52618355])
  end
end
