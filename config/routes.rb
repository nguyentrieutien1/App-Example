# frozen_string_literal: true

Rails.application.routes.draw do
  root "static_pages#home"

  # Chapter/3-4-5
  get "static_pages/home"
  get "static_pages/help"
  get "switch_language/:locale", to: "application#switch_language", as: "switch_language"
  get "up" => "rails/health#show", as: :rails_health_check

  # Chapter/6
  resources :users

  # Chapter/7
  get "sign_up", to: "users#new", as: "sign_up"

  # Chapter/8 + Chapter 9
  get "sessions/new"
  post "sessions/create"
  delete "sessions/destroy", as: "log_out"

  # Chapter/11
  get "activate/:activation_digest", to: "account_activations#edit", as: "activate_user", constraints: { activation_digest: /.*/ }

  # Chapter/12
  resources :password_resets, except: %i(index show), constraints: { id: /.*/ }
end
