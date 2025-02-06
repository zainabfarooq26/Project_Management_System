Rails.application.routes.draw do
  get "users/index"
  get "profiles/edit"
  get "profiles/update"
  namespace :manager do
    get "dashboard/index"
  end
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root "home#index"
  resources :users, only: [:index]
  resources:clients, only: [:index,:show]
  resource :profile, only: [:edit, :update]
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
  namespace :manager do
    resources :dashboard, only: [:index] # Dashboard route for the manager
    resources :clients do  # CRUD for managers to manage clients
      resources :projects do # CRUD for managers to manage projects
        resources :payments, only: [:index, :new, :create, :edit, :update, :destroy]
        resources :time_logs, only: [:index, :create, :destroy]  # Add index and create!
        resources :comments, only: [:create, :new, :edit, :update, :destroy]  
          get 'comments/new', to: 'comments#new', as: 'new_comment'

      end
    end
  end
  
end