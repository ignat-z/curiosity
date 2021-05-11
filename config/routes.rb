Rails.application.routes.draw do
  namespace :arcadia do
    resources :home, only: [:index, :create]

    root to: "home#index"
  end

  namespace :amaterasu do
    resources :home, only: :index

    resources :wizzard, only: :index
    namespace :wizzard do
      resources :names, only: [:new, :create]
      resources :emails, only: [:new, :create]
      resources :passwords, only: [:new, :create]
      resources :finish, only: [:index]
    end

    resources :catalog, only: :index
    resource :catalog_fragment, only: [:show]

    resources :repos, only: [:index, :show]

    resources :products, only: [:index]

    resources :colors, only: [:index]
    resource :colors_fragment, only: [:show]

    resources :lights, only: [:index]
    resource :lights_fragment, only: [:show, :update]

    root to: "home#index"
  end
end
