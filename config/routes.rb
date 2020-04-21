Rails.application.routes.draw do

  # Devise root scope - used to determine the authenticated
  # and unauthenticated root pages
  devise_scope :user do
    unauthenticated do
      root to: "user/sessions#new"
    end
    authenticated :user do
      root to: "dashboard#show", as: :authenticated_root
    end
  end

  # TODO: Remove bau flipper
  constraints lambda { !Flipper.enabled?(:bau) } do
    devise_scope :user do
      get "/users/sign_up",  :to => "devise/sessions#new"
    end
  end

  # Override the Devise registration controller, which allows us
  # to create an organisation when a user is created
  devise_for :users,
             :controllers  => {
                 registrations: 'user/registrations',
                 sessions: 'user/sessions'
             }

  # Account section of the service
  namespace :account do
    get 'create-new-account', to: 'account#new'
    get 'account-created', to: 'account#account_created'
  end

  # User section of the service
  namespace :user do
    get 'details', to: 'details#show'
    put 'details', to: 'details#update'
  end

  # Dashboard section of the service
  # TODO: Remove bau flipper
  get 'start-a-project', to: 'home#show',
      constraints: lambda { Flipper.enabled?(:bau) }
  get 'start-a-project', to: 'dashboard#show',
      constraints: lambda { !Flipper.enabled?(:bau) }

  # Modular address section of the service
  # Used in /user, /organisation and /3-10k/project
  scope '/:type/:id/address' do
    get '/postcode', to: 'address#postcode_lookup'
    post '/address-results',
         to: 'address#display_address_search_results'
    put '/address-details',
        to: 'address#assign_address_attributes'
    get '/address',
        to: 'address#show'
    put '/address',
        to: 'address#update'
    # This route ensures that attempting to navigate back to the list of
    # address results redirects the user back to the search page
    get '/address-results',
        to: 'address#postcode_lookup'
    # This route ensures that users can navigate back to the address details
    # page
    get '/address-details',
        to: 'address#show'
  end

  # Organisation section of the service
  namespace :organisation do
    scope '/:organisation_id' do
      get '/type', to: 'type#show'
      put '/type', to: 'type#update'
      get '/numbers', to: 'numbers#show'
      put '/numbers', to: 'numbers#update'
      get '/mission', to: 'mission#show'
      put '/mission', to: 'mission#update'
      get '/signatories', to: 'signatories#show'
      put '/signatories', to: 'signatories#update'
      get '/summary', to: 'summary#show'
    end
  end

  # Project section of the service (for small grants)
  scope "/3-10k", as: :three_to_ten_k do
    namespace :project do

      # Not scoped under /:project_id, as the project does not yet exist
      get 'create-new-project', to: 'new_project#create_new_project', as: :create

      scope '/:project_id' do
        get 'title', to: 'title#show'
        put 'title', to: 'title#update'
        get 'key-dates', to: 'dates#show'
        put 'key-dates', to: 'dates#update'
        get 'location', to: 'location#show'
        put 'location', to: 'location#update'
        get 'description', to: 'description#show'
        put 'description', to: 'description#update'
        get 'capital-works', to: 'capital_works#show'
        put 'capital-works', to: 'capital_works#update'
        get 'do-you-need-permission', to: 'permission#show'
        put 'do-you-need-permission', to: 'permission#update'
        get 'difference', to: 'difference#show'
        put 'difference', to: 'difference#update'
        get 'how-does-your-project-matter', to: 'matter#show'
        put 'how-does-your-project-matter', to: 'matter#update'
        get 'your-project-heritage', to: 'heritage#show'
        put 'your-project-heritage', to: 'heritage#update'
        get 'why-is-your-organisation-best-placed', to: 'best_placed#show'
        put 'why-is-your-organisation-best-placed', to: 'best_placed#update'
        get 'how-will-your-project-involve-people', to: 'involvement#show'
        put 'how-will-your-project-involve-people', to: 'involvement#update'
        get 'our-other-outcomes', to: 'outcomes#show'
        put 'our-other-outcomes', to: 'outcomes#update'
        get 'costs', to: 'costs#show'
        put 'costs', to: 'costs#update'
        delete 'costs/:project_cost_id', to: 'costs#delete', as: :cost_delete
        put 'confirm-costs', to: 'costs#validate_and_redirect'
        get 'are-you-getting-cash-contributions',
            to: 'cash_contributions#question'
        put 'are-you-getting-cash-contributions',
            to: 'cash_contributions#question_update'
        get 'cash-contributions', to: 'cash_contributions#show'
        put 'cash-contributions', to: 'cash_contributions#update'
        delete 'cash-contributions/:cash_contribution_id',
               to: 'cash_contributions#delete',
               as: :cash_contribution_delete
        get 'your-grant-request', to: 'grant_request#show'
        get 'are-you-getting-non-cash-contributions',
            to: 'non_cash_contributions#question'
        put 'are-you-getting-non-cash-contributions',
            to: 'non_cash_contributions#question_update'
        get 'non-cash-contributions', to: 'non_cash_contributions#show'
        put 'non-cash-contributions', to: 'non_cash_contributions#update'
        delete 'non-cash-contributions/:non_cash_contribution_id',
               to: 'non_cash_contributions#delete',
               as: :non_cash_contribution_delete
        get 'volunteers', to: 'volunteers#show'
        put 'volunteers', to: 'volunteers#update'
        delete 'volunteers/:volunteer_id', to: 'volunteers#delete',
               as: :volunteer_delete
        get 'evidence-of-support', to: 'evidence_of_support#show'
        put 'evidence-of-support', to: 'evidence_of_support#update'
        delete 'evidence-of-support/:supporting_evidence_id',
               to: 'evidence_of_support#delete',
               as: :evidence_of_support_delete
        get 'check-your-answers', to: 'check_answers#show'
        put 'check-your-answers', to: 'check_answers#update'
        get 'governing-documents', to: 'governing_documents#show'
        put 'governing-documents', to: 'governing_documents#update'
        get 'accounts', to: 'accounts#show'
        put 'accounts', to: 'accounts#update'
        get 'confirm-declaration', to: 'declaration#show_confirm_declaration'
        put 'confirm-declaration', to: 'declaration#update_confirm_declaration'
        get 'declaration', to: 'declaration#show_declaration'
        put 'declaration', to: 'declaration#update_declaration'
        get 'application-submitted', to: 'application_submitted#show'
      end

    end
  end

  # Static pages within the service
  get '/accessibility-statement', to: 'static_pages#show_accessibility_statement'

  # Support section of the service
  get 'support', to: 'support#show'
  post 'support', to: 'support#update'
  scope '/support' do
    # We use a scope here, as there is no related Support object
    get 'report-a-problem', to: 'support#report_a_problem'
    post 'report-a-problem', to: 'support#process_problem'
    get 'question-or-feedback', to: 'support#question_or_feedback'
    post 'question-or-feedback', to: 'support#process_question'
  end
  # Endpoint for released forms webhook
  post 'consumer' => 'released_form#receive' do
    header "Content-Type", "application/json"
  end

  # Health check route for GOV.UK PaaS
  get 'health' => 'health#get_status'

  namespace :help do
    get 'cookies'
    get 'cookie-details'
  end

  # DelayedJob dashboard
  match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]

end
