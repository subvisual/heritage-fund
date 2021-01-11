require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'date_of_birth' do
    it 'can be set from form params' do
      user = User.new

      user.assign_attributes({
                               'date_of_birth(3i)' => '1',
                               'date_of_birth(2i)' => '1',
                               'date_of_birth(1i)' => '1990'
                             })

      expect(user.date_of_birth).to eq Date.new(1990, 1, 1)
    end

    it 'fails to assign an invalid date' do
      user = User.new

      user.assign_attributes({
                               'date_of_birth(3i)' => '32',
                               'date_of_birth(2i)' => '14',
                               'date_of_birth(1i)' => '1990'
                             })

      user.validate_details = true

      expect(user).not_to be_valid
    end
  end
end
