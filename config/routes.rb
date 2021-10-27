Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :cards
      resources :sessions, only: [:create, :destroy]
      resources :users, only: [:create]
    end
  end
end
