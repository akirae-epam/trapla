class User < ApplicationRecord
#———————————————Validation————————————————
  #name
  validates :name, presence: true,
                   length: {maximum: 25},
                   uniqueness: true

  #email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}

  #password
  validates :password, presence: true,
                       length: {minimum: 6}
  has_secure_password
end
