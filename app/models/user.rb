class User < ApplicationRecord
  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true  
  validates :code, allow_blank: true, numericality: {only_integer: true}, length: { in: 1..4 }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end