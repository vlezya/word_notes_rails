Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :cards
      resources :card_decks, only: [:index]
      resources :decks do
        resources :cards, except: [:create, :destroy, :show, :index, :update] do
          resources :card_decks, only: [:create, :destroy]
            member do
              post :create, controller: :card_decks
              delete :destroy, controller: :card_decks
            end
        end
      end
      
      resources :sessions, only: [:create, :destroy], param: :token
      resources :users, only: [:create]
    end
  end
end
