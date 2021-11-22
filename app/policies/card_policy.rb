class CardPolicy
  attr_reader :user, :card
  
  def initialize(user, card)
    @user = user
    @card = card
  end
  
  def index?
    true
  end
  
  def show?
    card.user == user
  end
  
  def create?
   user.present?
  end
  
  def update?
    card.user == user
  end
  
  def destroy?
    card.user == user
  end
end
