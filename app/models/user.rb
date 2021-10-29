class User < ApplicationRecord
  has_secure_password
  
  # Constants
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # Associations
  has_many :sessions, dependent: :destroy
  
  # Associations validations
  
  # Field validations
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, on: :create
  
  # Setters
  def email=(value)
    email = value&.downcase&.strip
    super(email)
  end
end
