class Project::ProjectCostsController < ApplicationController

  def project_costs
    # TODO really persist and retrieve data
    activities = session['activities']
    equipment_and_materials = session['equipment_and_materials']
    people = session['people']
    other = session['other']
    contingency = session['contingency']
    evaluation = session['evaluation']

    @activities_cost = activities.nil? ? 0 : activities['cost-amount'].to_i
    @equipment_and_materials_cost = equipment_and_materials.nil? ? 0 : equipment_and_materials['cost-amount'].to_i
    @people_cost = people.nil? ? 0 : people['cost-amount'].to_i
    @other_cost = other.nil? ? 0 : other['cost-amount'].to_i
    @contingency_cost = contingency.nil? ? 0 : contingency['cost-amount'].to_i
    @evaluation_cost = evaluation.nil? ? 0 : evaluation['cost-amount'].to_i

    @total_costs = @activities_cost + @equipment_and_materials_cost + @people_cost + @other_cost + @contingency_cost + @evaluation_cost

    @activities_desc = activities.nil? ? '' : activities['cost-description']
    @equipment_and_materials_desc = equipment_and_materials.nil? ? '' : equipment_and_materials['cost-description']
    @people_desc = people.nil? ? '' : people['cost-description']
    @other_desc = other.nil? ? '' : other['cost-description']
    @contingency_desc = contingency.nil? ? '' : contingency['cost-description']
    @evaluation_desc = evaluation.nil? ? '' : evaluation['cost-description']

  end

  def add_cost

    cost_type = params['cost-type']
    cost_description = params['cost-description']
    cost_amount = params['cost-amount']

    session[cost_type.gsub(' ', '_').to_s.downcase] = { 'cost-description' => cost_description, 'cost-amount' => cost_amount }

    redirect_to '/project/costs#summary-section'
  end
end
