Rails.application.routes.draw do
  root "home#index"
  get "home/index"

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  namespace :dashboard do
    namespace :seller do
      root to: "home#index"

      resources :categories
      resources :products
      resource :seller_profile, only: [:show, :edit, :update]
    end
  end
end
