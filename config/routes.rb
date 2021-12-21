Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :cards
      resources :card_decks, only: [:index, :create, :destroy]
      resources :decks
      resources :sessions, only: [:create, :destroy], param: :token
      resources :users, only: [:create]
    end
  end
end
