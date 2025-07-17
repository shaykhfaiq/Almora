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

      get "variants/all", to: "variants#all_index", as: :all_variants

      resources :option_types do
        resources :option_values, only: [:index, :new, :create, :destroy]
      end

      resource :seller_detail, only: [:show, :edit, :update]
    end
  end

  
  namespace :buyer do
    
    resources :categories, only: [:index, :show]
    resources :products, only: [:index, :show]

    
    resource :cart, only: [:show] do
      resources :cart_items, only: [:create, :update, :destroy]
    end

    
    resources :orders, only: [:index, :show, :create, :new]

    
    get "checkout", to: "orders#new", as: :checkout
    post "checkout", to: "orders#create"
  end
end
