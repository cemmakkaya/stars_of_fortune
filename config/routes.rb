Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'devise/sessions'
  }, path: 'users', path_names: {
    sign_in: 'sign_in',
    sign_out: 'sign_out',
    sign_up: 'sign_up'
  }

  resource :profile, only: [:show, :edit, :update, :destroy]

  resources :groups do
    member do
      post 'join'
      post 'leave'
    end
  end

  resources :games, only: [:index, :new, :create, :show, :update]
  resources :histories, only: [:index]

  namespace :admin do
    get 'dashboard'
    resources :users, only: [:edit, :update, :destroy]
  end

  # PWA routes
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end