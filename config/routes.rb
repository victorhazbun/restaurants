require 'api_constraints'

Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
      post :user_token, to: 'user_token#create'

      resource :users, only: [:create]
      resources :restaurants, only: [:index]
      resources :transactions, only: [:index]
    end
  end
end
