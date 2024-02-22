# frozen_string_literal: true

Rails.application.routes.draw do
  root "static_pages#home"
  
  get "static_pages/home"
  get "static_pages/help"
  get "switch_language/:locale", to: "application#switch_language", as: "switch_language"
  get "up" => "rails/health#show", as: :rails_health_check
end
