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
          patch :toggle_status  
          patch :toggle_manager
         end
        end
  end
  namespace :manager do
    resources :dashboard, only: [:index] 
    resources :clients do
      resources :projects do
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
      post 'auth/register', to: 'authentication#register'
      post 'auth/login', to: 'authentication#login'
      delete 'auth/logout', to: 'authentication#logout'
      resources :projects, only: [:index, :show]
      namespace :admin do
        resources :projects, only: [:create, :update, :destroy]
        resources :payments, only: [:create, :update, :destroy]
      end
      namespace :manager do
        resources :projects, only: [:create, :update]
        resources :payments, only: [:create, :update]
      end
      namespace :user do
        resources :projects, only: [:index, :show]
      end
    end
  end
end