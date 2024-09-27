Rails.application.routes.draw do
  root to: 'home#index'

  # Devise routes for user authentication
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'devise/sessions'
  }, path: 'users', path_names: {
    sign_in: 'sign_in',
    sign_out: 'sign_out',
    sign_up: 'sign_up'
  }

  # Profile management routes
  resource :profile, only: [:show, :edit, :update]

  # Group and post routes
  resources :groups do
    member do
      post 'join'
      delete 'leave'
    end
    resources :posts, only: [:create]
  end

  # Game routes
  resources :games, only: [:index, :new, :create, :show] do
    member do
      post 'join'
    end
  end

  # History routes
  resources :histories, only: [:index]

  # Admin routes with group management
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :groups, only: [:create, :update, :destroy], controller: 'dashboard' do
      post 'create', on: :collection, action: 'create_group'
      patch 'update', on: :member, action: 'update_group'
      delete 'destroy', on: :member, action: 'destroy_group'
    end
    resources :users
  end

  # PWA routes
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end