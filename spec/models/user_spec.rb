require 'rails_helper'

RSpec.describe User, type: :model do
  context '#valid?' do
    it 'allows empty details without a context' do
      user = build(:user, name: nil)

      expect(user).to be_valid
    end

    it 'validates details with the :update_details context' do
      user = build(:user, name: nil)

      expect(user).not_to be_valid(:update_details)
    end

    it 'allows empty address without a context' do
      user = build(:user, county: nil)

      expect(user).to be_valid
    end

    it 'validates the address with the :update_address context' do
      user = build(:user, county: nil)

      expect(user).not_to be_valid(:update_address)
    end
  end
end
