require 'rails_helper'

RSpec.describe Person, type: :model do
  context '#valid?' do
    it 'accepts valid email addresses' do
      user = build(:person, email: 'test@gmail.com')
      user.validate_email = true

      expect(user).to be_valid
    end

    it 'does not accept invalid emails' do
      user = build(:person, email: 'test')
      user.validate_email = true

      expect(user).not_to be_valid
    end
  end
end
