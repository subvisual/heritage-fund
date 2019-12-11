class Project::ProjectLocationController < ApplicationController

  def project_location
  end

  def project_other_location
  end

  def save_project_location
    same_location = params['same-location'].to_s == 'yes' ? true : false unless params['same-location'].nil?

    # todo really save same_location data

    if (same_location == true)
      redirect_to '/project/description'
    else
      redirect_to '/project/other-location'
    end
  end
end
