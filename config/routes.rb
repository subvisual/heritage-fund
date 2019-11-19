Rails.application.routes.draw do

  resources :projects
  get 'dashboard/show'
  root 'home#show'
  get 'auth/auth0/callback' => 'auth0#callback'
  get 'auth/failure' => 'auth0#failure'
  get 'dashboard' => 'dashboard#show'
  get 'postcode' => 'postcode#show'
  post 'postcode_lookup' => 'postcode#lookup'
  post 'postcode_save' => 'postcode#save'
  get 'logout' => 'logout#logout'
  post 'consumer' => 'released_form#receive' do
    header "Content-Type", "application/json"
  end
  resources :organisation
end
