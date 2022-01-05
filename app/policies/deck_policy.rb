class DeckPolicy
  attr_reader :user, :deck
  
  def initialize(user, deck)
    @user = user
    @deck = deck
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
  
  def cards?
    deck.user == user
  end
end
