class User::RegistrationsController < Devise::RegistrationsController

  # Override the Devise::RegistrationsController create method
  # resource refers to the User object being created
  def create
      super do
        # Check that the user model is valid so that we do not create an empty
        # organisation if validation fails
        if resource.valid?
          organisation = Organisation.create
          resource.organisation_id = organisation.id
        end
        resource.save
      end
  end
end
