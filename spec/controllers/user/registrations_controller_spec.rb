require 'rails_helper'

RSpec.describe User::RegistrationsController do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  context 'POST #create' do
    it 'creates a user, person and organization records' do
      user_params = {
        email: 'test@email.com',
        password: '123456',
        password_confirmation: '123456'
      }

      post :create, params: { user: user_params }

      user = User.first

      expect(user.email).to eq 'test@email.com'
      expect(user.person).to be_a Person
      expect(user.organisations.size).to eq 1
    end
  end
end
