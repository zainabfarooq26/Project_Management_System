Rails.application.routes.draw do
  get "profiles/edit"
  get "profiles/update"
  namespace :manager do
    get "dashboard/index"
  end
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root "home#index"

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
        resources :time_logs, except: [:show]
        resources :comments, only: [:create, :edit, :update, :destroy]
      end
    end
  end
  namespace :users do
    resources :projects do
      resources :time_logs, except: [:show]
      resources :comments, only: [:create, :edit, :update, :destroy]
    end
  end
end