class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
    belongs_to :organisation, optional: true
    has_many :projects
   def self.find_or_create_from_auth_hash(auth_hash)
        User.find_or_create_by!(uid: auth_hash.uid) do |u|
            u.email = auth_hash.info['email']
        end
    end

    def self.current_user(user_id)
        @user = User.find_by(uid: user_id)
    end
end
