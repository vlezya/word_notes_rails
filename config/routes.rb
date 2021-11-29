Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :cards
      resources :decks, except: [:add_card, :remove_card]
      
      resources :decks, only: [:add_card, :remove_card] do
        resources :cards, except: [:create, :destroy, :show, :index, :update] do
          member do
            post :add, controller: :decks
            delete :remove, controller: :decks
          end
        end
      end
      
      resources :sessions, only: [:create, :destroy], param: :token
      resources :users, only: [:create]
    end
  end
end
