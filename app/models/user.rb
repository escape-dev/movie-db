class User < ApplicationRecord
  has_secure_password

  validates :name, :email, :password, presence: true
  validates :name, length: { maximum: 35 }
  validates :name, format: /\A[^0-9`!@#\$%\^&*+_=]+\z/
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
