Rails.application.routes.draw do

  namespace :account do
    get 'create-new-account' => 'account#new'
    get 'account-created' => 'account#account_created'
  end

  namespace :organisation do
    get ':organisation_id/type', to: 'organisation_type#show', as: :organisation_type_get
    put ':organisation_id/type', to: 'organisation_type#update', as: :organisation_type_put
    get ':organisation_id/numbers', to: 'organisation_numbers#show', as: :organisation_numbers_get
    put ':organisation_id/numbers', to: 'organisation_numbers#update', as: :organisation_numbers_put
    get ':organisation_id/about', to: 'organisation_about#show_postcode_lookup', as: :about_get
    put ':organisation_id/about', to: 'organisation_about#update', as: :about_put
    post ':organisation_id/about/address-results', to: 'organisation_about#display_address_search_results', as: :about_search_results
    get ':organisation_id/about/address', to: 'organisation_about#show', as: :about_address_get
    put ':organisation_id/about/address', to: 'organisation_about#assign_address_attributes', as: :about_assign_address_attributes
    # This route ensures that attempting to navigate back to the list of address results
    # redirects the user back to the search page
    get ':organisation_id/about/address-results', to: 'organisation_about#show_postcode_lookup'
    get ':organisation_id/mission', to: 'organisation_mission#show', as: :organisation_mission_get
    put ':organisation_id/mission', to: 'organisation_mission#update', as: :organisation_mission_put
    get ':organisation_id/signatories', to: 'organisation_signatories#show', as: :organisation_signatories_get
    put ':organisation_id/signatories', to: 'organisation_signatories#update', as: :organisation_signatories_put
    get ':organisation_id/organisation_summary', to: 'organisation_summary#show', as: :organisation_summary_get
  end

  scope "/3-10k", as: :three_to_ten_k do
    namespace :project do
      get 'create-new-project', to: 'new_project#create_new_project', as: :create

      get ':project_id/title', to: 'project_title#show', as: :title_get
      put ':project_id/title', to: 'project_title#update', as: :title_put

      get ':project_id/key-dates', to: 'project_dates#show', as: :dates_get
      put ':project_id/key-dates', to: 'project_dates#update', as: :dates_put

      get ':project_id/location', to: 'project_location#project_location', as: :location_get
      put ':project_id/location', to: 'project_location#update', as: :location_put

      # TODO: Refactor this into a single place for both organisation and projects
      get ':project_id/location/postcode', to: 'project_location#show_postcode_lookup', as: :location_postcode_get
      post ':project_id/location/address-results', to: 'project_location#display_address_search_results', as: :location_search_results
      put ':project_id/location/address', to: 'project_location#assign_address_attributes', as: :location_assign_address_attributes
      get ':project_id/location/address', to: 'project_location#entry', as: :location_address_get
      put ':project_id/location/address/add', to: 'project_location#different_location', as: :location_address_put
      # This route ensures that attempting to navigate back to the list of address results
      # redirects the user back to the search page
      get ':project_id/location/address-results', to: 'project_location#show_postcode_lookup'

      get ':project_id/description', to: 'project_description#show', as: :description_get
      put ':project_id/description', to: 'project_description#update', as: :description_put

      get ':project_id/capital-works', to: 'capital_works#capital_works', as: :capital_works_get

      get ':project_id/difference', to: 'project_difference#show', as: :difference_get
      put ':project_id/difference', to: 'project_difference#update', as: :difference_put

      get ':project_id/how-does-your-project-matter', to: 'project_matters#show', as: :matter_get
      put ':project_id/how-does-your-project-matter', to: 'project_matters#update', as: :matter_put

      get ':project_id/your-project-heritage', to: 'project_heritage#show', as: :heritage_get
      put ':project_id/your-project-heritage', to: 'project_heritage#update', as: :heritage_put

      get ':project_id/why-is-your-organisation-best-placed',
          to: 'project_best_placed#show', as: :best_placed_get
      put ':project_id/why-is-your-organisation-best-placed',
          to: 'project_best_placed#update', as: :best_placed_put

      get ':project_id/how-will-your-project-involve-people',
          to: 'project_involvement#show', as: :involvement_get
      put ':project_id/how-will-your-project-involve-people',
          to: 'project_involvement#update', as: :involvement_put

      get ':project_id/other-outcomes', to: 'project_other_outcomes#project_other_outcomes', as: :other_outcomes_get

      get ':project_id/costs' => 'project_costs#show', as: :project_costs
      put ':project_id/costs' => 'project_costs#update'

      get 'project-list' => 'project_list#project_list'
      get 'permission' => 'project_permission#project_permission'
      get 'location' => 'project_location#project_location'
      post 'save-project-contributions' => 'project_cash_contribution#save_cash_contribution_question'
      get 'cash-contributions-question' => 'project_cash_contribution#cash_contribution_question'
      post 'process-cash-contributions' => 'project_cash_contribution#process_cash_contributions'
      get 'non-cash-contributions-question' => 'project_non_cash_contributors#non_cash_contributors_question'
      post 'save-non-cash-contributions-question' => 'project_non_cash_contributors#save_non_cash_contributions_question'
      get 'non-cash-contribution' => 'project_non_cash_contributors#non_cash_contribution'
      post 'add-non-cash-contribution' => 'project_non_cash_contributors#add_non_cash_contribution'
      post 'process-non-cash' => 'project_non_cash_contributors#process_non_cash'
      get 'grant-request' => 'project_grant_request#grant_request'
      post 'grant-save-and-continue' => 'project_grant_request#grant_save_and_continue'
      get 'confirm-declaration' => 'project_declaration#confirm_declaration'
      get 'declaration' => 'project_declaration#project_declaration'
      post 'declaration-confirmed' => 'project_declaration#declaration_confirmed'
      post 'submit-application' => 'project_declaration#submit_application'
      get 'volunteers' => 'project_volunteers#project_volunteers'
      post 'add-volunteer' => 'project_volunteers#add_volunteer'
      post 'process-volunteers' => 'project_volunteers#process_volunteers'
      get ':project_id/support-evidence' => 'project_support_evidence#project_support_evidence', as: :project_support_evidence
      put ':project_id/support-evidence' => 'project_support_evidence#put'
      get ':project_id/cash-contribution' => 'project_cash_contribution#project_cash_contribution', as: :project_cash_contribution
      put ':project_id/cash-contribution' => 'project_cash_contribution#put'
    end
  end

  get 'health' => 'health#get_status'

  devise_for :users
  resources :projects, except: [:destroy, :index]
  root to: "dashboard#show"
  get 'start-a-project', to: 'home#show', as: :start_a_project
  get 'logout' => 'logout#logout'
  post 'consumer' => 'released_form#receive' do
    header "Content-Type", "application/json"
  end
  resources :organisation do
    get 'show'
  end
end
