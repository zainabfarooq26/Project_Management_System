Rails.application.routes.draw do
  get "users/index"
  get "users/show"
  get "users/update"

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root "home#index"

  resources :users, only: [:index, :show, :update] 

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :users, only: [:index] do
      member do
        patch :toggle_status # Route to enable/disable users
      end
    end  # <-- This closes the `resources :users` block
  end  # <-- This closes the `namespace :admin` block
end  # <-- This closes `Rails.application.routes.draw do`
