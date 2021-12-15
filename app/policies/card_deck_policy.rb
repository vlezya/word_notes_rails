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
   true
  end
  
  def destroy?
   true
  end
end
