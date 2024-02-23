# frozen_string_literal: true

Rails.application.routes.draw do
  root "static_pages#home"
  
  # Chapter/3-4-5
  get "static_pages/home"
  get "static_pages/help"
  get "switch_language/:locale", to: "application#switch_language", as: "switch_language"
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Chapter/6
  get "users", to: "users#index", as: "get_user_form"
  get "users/:id", to: "users#show", as: "get_user"
  post "users", to: "users#create", as: "create_user"
  
  # Chapter/7
  get "/signup", to: "users#new"
end
