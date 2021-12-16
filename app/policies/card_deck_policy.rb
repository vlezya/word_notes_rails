class CardDeckPolicy
  attr_reader :user, :card_deck
  
  def initialize(user, card_deck)
    @user = user
    @card_deck = card_deck
  end
  
  def index?
    true
  end
  
  def create?
    card_deck.card.user == user && card_deck.deck.user == user
  end
  
  def destroy?
    card_deck.card.user == user && card_deck.deck.user == user
  end
end
