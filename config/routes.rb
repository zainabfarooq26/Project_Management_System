Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root "home#index"
  resources :users, only: [:index, :show, :update] 
    namespace :admin do
      get 'dashboard', to: 'dashboard#index'
      resources :dashboard, only: [:index]
      resources :users do
        member do
          patch :toggle_status  # Route for enabling/disabling a user
          patch :toggle_manager
        end
      end
    end
end