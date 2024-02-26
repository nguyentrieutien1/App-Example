# frozen_string_literal: true

Rails.application.routes.draw do
  root "static_pages#home"

  # Chapter/3-4-5
  get "static_pages/home"
  get "static_pages/help"
  get "switch_language/:locale", to: "application#switch_language", as: "switch_language"
  get "up" => "rails/health#show", as: :rails_health_check

  # Chapter/6
  resources :users, only: %i(create show)

  # Chapter/7
  get "/sign_up", to: "users#new", as: "sign_up"
end
