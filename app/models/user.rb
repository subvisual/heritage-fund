class User < ApplicationRecord
    belongs_to :organisation, optional: true
   def self.find_or_create_from_auth_hash(auth_hash)
        User.find_or_create_by!(uid: auth_hash.uid) do |u|
            u.email = auth_hash.info['email']
        end
    end
end
