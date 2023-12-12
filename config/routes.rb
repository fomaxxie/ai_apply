Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: "pages#home"
  get "/dashboard", to: "pages#dashboard", as: 'dashboard'
  resources :profiles do
    resources :letters, only: [:new, :create]
    resources :bios
  end

  resources :letters, only: [:index, :show, :destroy]
end
