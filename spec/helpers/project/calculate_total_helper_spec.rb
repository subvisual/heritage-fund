require 'rails_helper'

RSpec.describe Project::CalculateTotalHelper do

  describe '#calculate_total' do
    it 'adds costs' do
      project = create(:project)
      create(:project_cost, amount: 10, cost_type: 'new_staff', description: 'description', project_id: project.id )
      create(:project_cost, amount: 20, cost_type: 'new_staff', description: 'description', project_id: project.id )
      expect(calculate_total(project.project_costs)).to eq(30)
    end
  end

end
