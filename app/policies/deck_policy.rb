class DeckPolicy
  attr_reader :user, :deck, :card
  
  def initialize(user, deck, card)
    @user = user
    @deck = deck
    @card = card
  end
  
  def index?
    true
  end
  
  def show?
    deck.user == user
  end
  
  def create?
    true
  end
  
  def update?
    deck.user == user
  end
  
  def destroy?
    deck.user == user
    
  end
  
  def add_card?
    deck.user == user && card.user == user
  end
  
  def remove_card?
    deck.user == user && card.user == user
  end
end
