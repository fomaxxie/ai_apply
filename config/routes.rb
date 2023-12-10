Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: "pages#home"
  get "/dashboard", to: "pages#dashboard", as: 'dashboard'
  resources :profiles
  #   resources :bios
  #   resources :letters
  # end
end
