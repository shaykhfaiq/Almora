Rails.application.routes.draw do
  root "home#index"
  get "home/index"

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  namespace :dashboard do
    namespace :seller do
      root to: "home#index"

      resources :categories

      resources :products do
        resources :variants
        resources :product_option_types, only: [:index, :new, :create, :destroy]
      end

      resources :option_types do
        resources :option_values, only: [:index, :new, :create, :destroy]
      end

      resource :seller_detail, only: [:show, :edit, :update]
    end
  end
end
