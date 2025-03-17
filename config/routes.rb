Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :chats, only: [ :index, :show, :new, :create ]
  root "chats#index"
end
