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

  resources :groups do
    member do
      post 'join'
    end
  end
  
  resources :games, only: [:create, :show, :update]
  resources :histories, only: [:index]

  # Wenn Sie eine separate Home-Seite zusätzlich zur Root-Route benötigen
  get 'home/index'

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end