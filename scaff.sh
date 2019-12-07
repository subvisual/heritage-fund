# Organisation controller and views
rails g controller organisation/organisation_about organisation_about
rails g controller organisation/organisation_mission organisation_mission
rails g controller organisation/legal_signatory legal_signatory
rails g controller organisation/summary summary

# Project controller and views
rails g controller project/new_project new_project
rails g controller project/about about
rails g controller project/project_dates project_dates
rails g controller project/project_location project_location project_location_no
rails g controller project/project_description project_description
rails g controller project/project_permission project_permission
rails g controller project/project_differences project_differences
rails g controller project/project_community project_community
rails g controller project/project_availability project_availability
rails g controller project/project_best_placed project_best_placed
rails g controller project/project_involvement project_involvement
rails g controller project/project_other_outcomes project_other_outcomes
rails g controller project/project_cash_contribution project_cash_contribution project_cash_contribution_yes

# Grant controllers and views
rails g controller grant/grant_request grant_request
rails g controller grant/grant_non_cash_contributors grant_non_cash_contributors
rails g controller grant/grant_volunteers grant_volunteers
rails g controller grant/grant_support_evidence grant_support_evidence
rails g controller grant/grant_summary grant_summary
rails g controller grant/grant_declaration grant_declaration
rails g controller grant/grant_application grant_application
