Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :cards
      resources :decks do
        member do
          post :add_card
          delete :remove_card
        end
      end
      resources :sessions, only: [:create, :destroy], param: :token
      resources :users, only: [:create]
    end
  end
end

# post 'cards/:id', to: 'decks#add_card'
# delete 'cards/:id', to: 'decks#remove_card'
