class Project::ProjectVolunteersController < ApplicationController
  def project_volunteers
    @current_volunteers = volunteers
    @total_volunteer_hours = total_volunteers_hours
  end

  def add_volunteer

    volunteer_amount = params['volunteer-amount'].present? ? params['volunteer-amount'].to_i : 0
    volunteer_description = params['volunteer-description'].present? ? params['volunteer-description'] : ' '

    volunteer = { 'description' => volunteer_description, 'amount' => volunteer_amount }

    current_volunteers = volunteers
    current_volunteers[current_volunteers.size] = volunteer unless volunteer_amount == 0
    session['volunteers'] = current_volunteers unless volunteer_amount == 0

    # TODO persist volunteers to the db

    redirect_to request.referer

  end

  def volunteers
    # TODO get volunteers from the db
    current_volunteers = session['volunteers'].present? ? session['volunteers'] : Array.new
    current_volunteers
  end

  def total_volunteers_hours
    # TODO calc totals from data in the db
    sum = 0
    current_volunteers = volunteers
    current_volunteers.each do |volunteer|
      sum += volunteer['amount']
    end
    sum
  end


end
