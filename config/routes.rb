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

  resources :profiles
  resources :letters, only: [:new, :create, :index, :show,:destroy]
  resources :bios
end
