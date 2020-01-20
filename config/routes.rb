Rails.application.routes.draw do

  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new"
    end
    authenticated :user do
      root to: "dashboard#show", as: :authenticated_root
    end
  end

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

      get ':project_id/capital-works', to: 'project_capital_works#show', as: :capital_works_get
      put ':project_id/capital-works', to: 'project_capital_works#update', as: :capital_works_put

      get ':project_id/do-you-need-permission', to: 'project_permission#show', as: :permission_get
      put ':project_id/do-you-need-permission', to: 'project_permission#update', as: :permission_put

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

      get ':project_id/our-other-outcomes', to: 'project_outcomes#show', as: :other_outcomes_get
      put ':project_id/our-other-outcomes', to: 'project_outcomes#update', as: :other_outcomes_put

      get ':project_id/costs' => 'project_costs#show', as: :project_costs
      put ':project_id/costs' => 'project_costs#update'

      get ':project_id/are-you-getting-cash-contributions',
          to: 'project_cash_contribution#question',
          as: :cash_contributions_question_get
      put ':project_id/are-you-getting-cash-contributions',
          to: 'project_cash_contribution#question_update',
          as: :cash_contributions_question_put

      get ':project_id/non-cash-contributions', to: 'project_non_cash_contributions#show', as: :non_cash_contributions_get
      put ':project_id/non-cash-contributions', to: 'project_non_cash_contributions#update', as: :non_cash_contributions_put

      get ':project_id/volunteers' => 'project_volunteers#show', as: :volunteers
      put ':project_id/volunteers' => 'project_volunteers#put'

      get ':project_id/check-your-answers',
          to: 'project_check_answers#show', as: :check_answers_get

      get ':project_id/declaration', to: 'project_declaration#show_declaration', as: :declaration_get
      put ':project_id/declaration', to: 'project_declaration#update_declaration', as: :declaration_put

      get ':project_id/confirm-declaration',
          to: 'project_declaration#show_confirm_declaration',
          as: :confirm_declaration_get
      put ':project_id/confirm-declaration',
          to: 'project_declaration#update_confirm_declaration',
          as: :confirm_declaration_put

      # TODO: Replace this with an 'application submitted' route
      get ':project_id/declaration-confirmed',
          to: 'project_declaration#declaration_confirmed',
          as: :declaration_confirmed_get

      get 'project-list' => 'project_list#project_list'
      get 'location' => 'project_location#project_location'


      post 'process-cash-contributions' => 'project_cash_contribution#process_cash_contributions'
      get 'grant-request' => 'project_grant_request#project_grant_request'
      post 'grant-save-and-continue' => 'project_grant_request#grant_save_and_continue'
      post 'submit-application' => 'show_declaration#submit_application'
      get ':project_id/support-evidence' => 'project_support_evidence#project_support_evidence', as: :project_support_evidence
      put ':project_id/support-evidence' => 'project_support_evidence#put'
      get ':project_id/cash-contribution' => 'project_cash_contribution#project_cash_contribution', as: :project_cash_contribution
      put ':project_id/cash-contribution' => 'project_cash_contribution#put'

    end
  end

  get 'health' => 'health#get_status'

  devise_for :users
  resources :projects, except: [:destroy, :index]
  get 'start-a-project', to: 'home#show', as: :start_a_project
  get 'logout' => 'logout#logout'
  post 'consumer' => 'released_form#receive' do
    header "Content-Type", "application/json"
  end
  resources :organisation do
    get 'show'
  end
end
