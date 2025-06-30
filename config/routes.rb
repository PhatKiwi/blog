Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  resources :posts do
    member do
      get :publish
    end
    resources :comments, only: [:create, :new, :destroy]
    resources :likes, only: [:create, :destroy]
  end

  # Defines the root path route ("/")
  root "posts#index"
end
