Rails.application.routes.draw do

  resources :projects
  get 'dashboard/show'
  root 'home#show'
  get 'auth/auth0/callback' => 'auth0#callback'
  get 'auth/failure' => 'auth0#failure'
  get 'dashboard' => 'dashboard#show'
  get 'logout' => 'logout#logout'
  resources :organisation
end
