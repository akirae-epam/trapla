class User < ApplicationRecord
#———————————————————————————————事前処理———————————————————————————————
  #emailは.save前に矯正的に小文字に変換する
  before_save { self.email = email.downcase }

#———————————————————————————————Validation———————————————————————————————
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

#———————————————————————————————クラスメソッド———————————————————————————————
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
