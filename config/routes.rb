Rails.application.routes.draw do
  namespace :amaterasu do
    resources :home, only: :index

    resources :colors, only: [:index]
    resource :colors_fragment, only: [:show]

    resources :lights, only: [:index]
    resource :lights_fragment, only: [:show, :update]

    root to: "home#index"
  end
end
