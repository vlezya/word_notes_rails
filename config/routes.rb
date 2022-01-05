Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :cards do
        member do
          put :decks, controller: :cards
        end
      end
      resources :card_decks, only: [:index, :create, :destroy]
      resources :decks
      resources :sessions, only: [:create, :destroy], param: :token
      resources :users, only: [:create]
    end
  end
end
