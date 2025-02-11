Rails.application.routes.draw do
  get "users/index"
  namespace :manager do
    get "dashboard/index"
  end
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root "home#index"
  resources :users, only: [:index]
  resources:clients, only: [:index,:show]
  resource :profile, only: [:show,:edit, :update]
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
    resources :clients do
      resources :projects do
        collection do
          get 'assignedprojects', to: 'projects#assigned_projects'
        end
        member do
          get 'assign_users'
          post 'assign_users', to: 'projects#assign_users'
          delete 'remove_user/:user_id', to: 'projects#remove_user', as: 'remove_user'
        end
        resources :payments, only: [:index, :new, :create, :edit, :update, :destroy]
        resources :time_logs, only: [:create, :new, :edit, :update, :destroy]
        resources :comments, only: [:create, :new, :edit, :update, :destroy]
        get 'comments/new', to: 'comments#new', as: 'new_comment'
      end
    end
  end
  
  namespace :api do
    namespace :v1 do
    end
  end
end