Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
      resources :users, only: [:create]
      resources :cards
    end
  end
end
