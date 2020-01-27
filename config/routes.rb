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
    get 'create-new-account', to: 'account#new'
    get 'account-created', to: 'account#account_created'
  end

  namespace :user do
    get 'details', to: 'details#show'
    put 'details', to: 'details#update'

    get 'address', to: 'address#show_postcode_lookup'
    put 'address', to: 'address#update'

    post 'address/results',
         to: 'address#display_address_search_results',
         as: :search_results
    get 'address/show',
        to: 'address#show',
        as: :user_address_get
    put 'address/show',
        to: 'address#assign_address_attributes',
        as: :assign_address_attributes
    # This route ensures that attempting to navigate back to the list of address results
    # redirects the user back to the search page
    get 'address/results', to: 'address#show_postcode_lookup'

  end

  namespace :organisation do
    scope '/:organisation_id' do
      get '/type', to: 'type#show'
      put '/type', to: 'type#update'
      get '/numbers', to: 'numbers#show'
      put '/numbers', to: 'numbers#update'

      # The following routes relate to the address lookup flow for an organisation
      # TODO: Refactor these into a reusable component for address lookup
      get '/about', to: 'about#show_postcode_lookup'
      put '/about', to: 'about#update'
      post '/about/address-results',
           to: 'about#display_address_search_results',
           as: :about_search_results
      get '/about/address',
          to: 'about#show',
          as: :about_address_get
      put '/about/address',
          to: 'about#assign_address_attributes',
          as: :about_assign_address_attributes
      # This route ensures that attempting to navigate back to the list of address results
      # redirects the user back to the search page
      get '/about/address-results', to: 'about#show_postcode_lookup'

      get '/mission', to: 'mission#show'
      put '/mission', to: 'mission#update'
      get '/signatories', to: 'signatories#show'
      put '/signatories', to: 'signatories#update'
      get '/summary', to: 'summary#show'
    end
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

      get ':project_id/costs', to: 'project_costs#show', as: :project_costs
      put ':project_id/costs', to: 'project_costs#update'

      delete ':project_id/costs/:project_cost_id', to: 'project_costs#delete', as: :cost_delete

      put ':project_id/confirm-costs',
          to: 'project_costs#validate_and_redirect',
          as: :project_costs_validate_and_redirect

      get ':project_id/are-you-getting-cash-contributions',
          to: 'project_cash_contribution#question',
          as: :cash_contributions_question_get
      put ':project_id/are-you-getting-cash-contributions',
          to: 'project_cash_contribution#question_update',
          as: :cash_contributions_question_put

      get ':project_id/cash-contributions',
          to: 'project_cash_contribution#show',
          as: :project_cash_contribution
      put ':project_id/cash-contributions', to: 'project_cash_contribution#put'

      delete ':project_id/cash-contributions/:cash_contribution_id',
             to: 'project_cash_contribution#delete',
             as: :cash_contribution_delete

      get ':project_id/your-grant-request' => 'project_grant_request#show', as: :grant_request_get

      get ':project_id/are-you-getting-non-cash-contributions',
          to: 'project_non_cash_contributions#question',
          as: :non_cash_contributions_question_get
      put ':project_id/are-you-getting-non-cash-contributions',
          to: 'project_non_cash_contributions#question_update',
          as: :non_cash_contributions_question_put

      get ':project_id/non-cash-contributions', to: 'project_non_cash_contributions#show', as: :non_cash_contributions_get
      put ':project_id/non-cash-contributions', to: 'project_non_cash_contributions#update', as: :non_cash_contributions_put

      delete ':project_id/non-cash-contributions/:non_cash_contribution_id',
             to: 'project_non_cash_contributions#delete',
             as: :non_cash_contribution_delete

      get ':project_id/volunteers', to: 'project_volunteers#show', as: :volunteers
      put ':project_id/volunteers', to: 'project_volunteers#put'

      delete ':project_id/volunteers/:volunteer_id', to: 'project_volunteers#delete', as: :volunteer_delete

      get ':project_id/evidence-of-support', to: 'project_support_evidence#show', as: :project_support_evidence
      put ':project_id/evidence-of-support', to: 'project_support_evidence#put'

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

      get ':project_id/application-submitted',
          to: 'project_application_submitted#show',
          as: :application_submitted_get

      get 'project-list' => 'project_list#project_list'
      get 'location' => 'project_location#project_location'

    end
  end

  get 'health' => 'health#get_status'

  devise_for :users
  get 'start-a-project', to: 'home#show', as: :start_a_project
  get 'logout' => 'logout#logout'
  post 'consumer' => 'released_form#receive' do
    header "Content-Type", "application/json"
  end
  resources :organisation do
    get 'show'
  end
  # TODO Put this behind auth on PAAS
  match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]
end
