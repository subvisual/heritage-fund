Rails.application.routes.draw do

  devise_for :users
  resources :projects
  get 'dashboard/show'
  root to: "home#show"
  get 'dashboard' => 'dashboard#show'
  get 'postcode' => 'postcode#show'
  post 'postcode_lookup' => 'postcode#lookup'
  post 'postcode_save' => 'postcode#save'
  get 'logout' => 'logout#logout'
  post 'consumer' => 'released_form#receive' do
    header "Content-Type", "application/json"
  end
  resources :organisation do
    get 'show'
  end
end
