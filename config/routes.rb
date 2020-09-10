Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :amaterasu do
    resources :home, only: :index
    resource :light, only: [:show, :update]
    root to: "home#index"
  end
end
