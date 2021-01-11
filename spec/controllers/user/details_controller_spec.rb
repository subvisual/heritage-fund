require 'rails_helper'

RSpec.describe User::DetailsController do
  login_user
  render_views

  describe 'PUT /user/details' do
    it 'should update the user with valid details' do
      user_params = {
        :name => 'Name',
        'date_of_birth(3i)' => '1',
        'date_of_birth(2i)' => '1',
        'date_of_birth(1i)' => '1990',
        :phone_number => '123123123'
      }

      put :update, params: { user: user_params }

      expect(response).to be_redirect

      expect(subject.current_user.name).to eq 'Name'
      expect(subject.current_user.date_of_birth).to eq Date.new(1990, 1, 1)
    end
  end

  it 'displays an error when given an invalid date' do
    user_params = {
      :name => 'Name',
      'date_of_birth(3i)' => '31',
      'date_of_birth(2i)' => '2',
      'date_of_birth(1i)' => '1990',
      :phone_number => '123123123'
    }

    put :update, params: { user: user_params }

    expect(response.body).to include 'is not a valid date'
  end

  it 'displays an error when given an empty date' do
    user_params = {
      :name => 'Name',
      'date_of_birth(3i)' => '',
      'date_of_birth(2i)' => '14',
      'date_of_birth(1i)' => '1990',
      :phone_number => '123123123'
    }

    put :update, params: { user: user_params }

    expect(response.body).to include 'is not a valid date'
  end
end
