Rails.application.routes.draw do

  # Lambdas are used in this file where we conditionally want to redirect routes
  # based on Flipper configuration settings. The use of lambdas is so that the 
  # corresponding Flipper.enabled check happens dynamically when the route is 
  # accessed, rather than when the routes are first initialised at runtime.

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

  constraints lambda { !Flipper.enabled?(:registration_enabled) } do
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
  get '/orchestrate-dashboard-journey', to: 'dashboard#orchestrate_dashboard_journey', constraints: lambda { Flipper.enabled?(:new_applications_enabled) }
  get '/orchestrate-dashboard-journey', to: redirect('/', status: 302), constraints: lambda { !Flipper.enabled?(:new_applications_enabled) }

  # Start an Application section of the service
  get 'start-an-application', to: 'new_application#show', constraints: lambda { Flipper.enabled?(:new_applications_enabled) }
  get 'start-an-application', to: redirect('/', status: 302), constraints: lambda { !Flipper.enabled?(:new_applications_enabled) }

  put 'start-an-application', to: 'new_application#update', constraints: lambda { Flipper.enabled?(:new_applications_enabled) }
  put 'start-an-application', to: redirect('/', status: 302), constraints: lambda { !Flipper.enabled?(:new_applications_enabled) }

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

  # Pre-application section of the service
  scope '/pre-application', module: 'pre_application', as: :pre_application do
    
    scope 'project-enquiry', module: 'project_enquiry', as: :project_enquiry do
    
      get 'start', to: 'start#show'
      post 'start', to: 'start#update'

      scope '/:pre_application_id' do

        get 'previous-contact', to: 'previous_contact_name#show'
        put 'previous-contact', to: 'previous_contact_name#update'
        get 'heritage-focus', to: 'heritage_focus#show'
        put 'heritage-focus', to: 'heritage_focus#update'
        get 'what-will-the-project-do', to: 'what_project_does#show'
        put 'what-will-the-project-do', to: 'what_project_does#update'
        get 'programme-outcomes', to: 'programme_outcomes#show'
        put 'programme-outcomes', to: 'programme_outcomes#update'
        get 'why-you-want-to-do-this-project', to: 'project_reasons#show'
        put 'why-you-want-to-do-this-project', to: 'project_reasons#update'
        get 'who-will-be-involved', to: 'project_participants#show'
        put 'who-will-be-involved', to: 'project_participants#update'
        get 'timescales', to: 'project_timescales#show'
        put 'timescales', to: 'project_timescales#update'
        get 'likely-cost', to: 'project_likely_cost#show'
        put 'likely-cost', to: 'project_likely_cost#update'
        get 'likely-ask', to: 'potential_funding_amount#show'
        put 'likely-ask', to: 'potential_funding_amount#update'
        get 'submitted', to: 'submitted#show'

      end

    end

    scope 'expression-of-interest', module: 'expression_of_interest', as: :expression_of_interest do

      get 'start', to: 'start#show'
      post 'start', to: 'start#update'

      scope '/:pre_application_id' do
        
        get 'heritage-focus', to: 'heritage_focus#show'
        put 'heritage-focus', to: 'heritage_focus#update'
        get 'what-will-the-project-do', to: 'what_project_does#show'
        put 'what-will-the-project-do', to: 'what_project_does#update'
        get 'programme-outcomes', to: 'programme_outcomes#show'
        put 'programme-outcomes', to: 'programme_outcomes#update'
        get 'why-you-want-to-do-this-project', to: 'project_reasons#show'
        put 'why-you-want-to-do-this-project', to: 'project_reasons#update'
        get 'feasibility-or-options-work', to: 'feasibility_or_options_work#show'
        put 'feasibility-or-options-work', to: 'feasibility_or_options_work#update'
        get 'timescales', to: 'project_timescales#show'
        put 'timescales', to: 'project_timescales#update'
        get 'overall_cost', to: 'overall_cost#show'
        put 'overall_cost', to: 'overall_cost#update'
        get 'likely-ask', to: 'potential_funding_amount#show'
        put 'likely-ask', to: 'potential_funding_amount#update'
        get 'likely-submission-description', to: 'likely_submission_description#show'
        put 'likely-submission-description', to: 'likely_submission_description#update'
        get 'submitted', to: 'submitted#show'
      end

    end

  end

  # Application section of the service
  scope '/application', module: 'funding_application', as: :funding_application do
 
    scope 'gp-project', module: 'gp_project', as: :gp_project do

      get 'start', to: 'start#show', constraints: lambda { Flipper.enabled?(:new_applications_enabled) }
      get 'start', to: redirect('/', status: 302), constraints: lambda { !Flipper.enabled?(:new_applications_enabled) }
      post 'start', to: 'start#update', constraints: lambda { Flipper.enabled?(:new_applications_enabled) }
      post 'start', to: redirect('/', status: 302), constraints: lambda { !Flipper.enabled?(:new_applications_enabled) }

      scope '/:application_id' do

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
        get 'project-difference', to: 'difference#show'
        put 'project-difference', to: 'difference#update'
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
        put 'declaration', to: 'declaration#update_declaration', constraints: lambda { Flipper.enabled?(:new_applications_enabled) }
        put 'declaration', to: redirect('/', status: 302), constraints: lambda { !Flipper.enabled?(:new_applications_enabled) }
        get 'application-submitted', to: 'application_submitted#show'

        scope '/payment', as: 'payment' do

          get 'details', to: 'payment_details#show'
          put 'details', to: 'payment_details#update'

          get 'confirm-details', to: 'payment_confirm_details#show'
          put 'confirm-details', to: 'payment_confirm_details#update'
          put 'confirm-details-submitted', to: 'payment_confirm_details#save_and_continue'

          get 'how-is-your-project-progressing', to: 'progress#show'
          get 'tell-us-what-you-have-spent', to: 'current_spend#show'
          get 'review-your-spending', to: 'review_spend#show'

          get 'submitted', to: 'payment_details_submitted#show'

        end

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
  get 'health' => 'health#status'

  namespace :help do
    get 'cookies'
    get 'cookie-details'
  end

  # DelayedJob dashboard
  match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]

end
