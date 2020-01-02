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

      get 'new' => 'new_project#new_project'
      # TODO: Remove this when creation of project is wired up
      put 'new', to: 'new_project#temp_create_new_project', as: :temp_create_new

      get ':project_id/title', to: 'project_title#show', as: :title_get
      put ':project_id/title', to: 'project_title#update', as: :title_put

      get ':project_id/key-dates', to: 'project_dates#project_dates', as: :dates_get

      get ':project_id/description', to: 'project_description#show', as: :description_get
      put ':project_id/description', to: 'project_description#update', as: :description_put

      get ':project_id/capital-works', to: 'capital_works#capital_works', as: :capital_works_get

      get 'project-list' => 'project_list#project_list'
      get 'other-outcomes' => 'project_other_outcomes#project_other_outcomes'
      get 'involvement' => 'project_involvement#project_involvement'
      get 'best-placed' => 'project_best_placed#project_best_placed'
      get 'availability' => 'project_availability#project_availability'
      get 'community' => 'project_community#project_community'
      get 'differences' => 'project_differences#project_differences'
      get 'permission' => 'project_permission#project_permission'
      get 'location' => 'project_location#project_location'
      post 'save-location' => 'project_location#save_project_location'
      get 'other-location' => 'project_location#project_other_location'
      get 'costs' => 'project_costs#project_costs'
      post 'save-project-contributions' => 'project_cash_contribution#save_cash_contribution_question'
      get 'cash-contributions-question' => 'project_cash_contribution#cash_contribution_question'
      get 'cash-contribution' => 'project_cash_contribution#project_cash_contribution'
      post 'add-cash-contribution' => 'project_cash_contribution#add_cash_contribution'
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
      post 'add-project-cost' => 'project_costs#add_cost'
      get ':project_id/support-evidence' => 'project_support_evidence#project_support_evidence', as: :project_support_evidence
      put ':project_id/support-evidence' => 'project_support_evidence#put'
    end
  end

  get 'health' => 'health#get_status'

  devise_for :users
  resources :projects, except: [:destroy, :index]
  get 'dashboard/show'
  root to: "home#show"
  get 'dashboard' => 'dashboard#show'
  get 'logout' => 'logout#logout'
  post 'consumer' => 'released_form#receive' do
    header "Content-Type", "application/json"
  end
  resources :organisation do
    get 'show'
  end
end
