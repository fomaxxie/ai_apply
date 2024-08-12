Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: "pages#home"
  get "/dashboard", to: "pages#dashboard", as: 'dashboard'
  get "/about", to: "pages#about", as: 'about'
  get "/contact", to: "pages#contact", as: 'contact'
  get "/terms", to: "pages#terms", as: 'terms'
  get "/privacy", to: "pages#privacy", as: 'privacy'
  get 'subscription', to: 'pages#subscription', as: 'subscription_page'

  resources :profiles, except: [:index]
  resources :letters, except: [:index]
  resources :bios, except: [:index]

  # Routes for Checkout actions
  get 'checkout/create', to: 'checkout#create', as: 'checkout_create'
  get 'checkout/success', to: 'checkout#success', as: 'checkout_success'
  get 'checkout/cancel', to: 'checkout#cancel', as: 'checkout_cancel'
end
