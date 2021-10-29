class Session < ApplicationRecord
  has_secure_token :token
  
  # Constants
  OPERATIONAL_SYSTEMS = %w[Android iOS].freeze
  
  # Associations
  belongs_to :user
  
  # Associations validations
  
  # Fields validations
  validates :operational_system, presence: true, inclusion: { in: OPERATIONAL_SYSTEMS }
end
