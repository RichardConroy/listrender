# frozen_string_literal: true

Rails.application.routes.draw do
  # TODO: restrict the routes to index/like
  resources :articles, only: [:index, :show] do
    member do
      post :like
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
