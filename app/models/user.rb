class User < ApplicationRecord
#———————————————————————————————事前処理———————————————————————————————
  attr_accessor :remember_token, :activation_token

  before_save :downcase_email
  before_create :create_activation_digest
#———————————————————————————————Validation———————————————————————————————
  validates :name, presence: true,
                   length: {maximum: 25},
                   uniqueness: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}

  validates :password, presence: true,
                       length: {minimum: 6},
                       allow_nil: true
  has_secure_password

#———————————————————————————————クラスメソッド———————————————————————————————
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #アカウントを有効化する
  def activate
    self.update_attributes(activated: true, activated_at: Time.zone.now)
  end

  # 永続セッションのためにユーザーをデータベースremember_digestカラムに記憶する
  def cookie_remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def token_authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def cookie_forget
    update_attribute(:remember_digest, nil)
  end

  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email.downcase!
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
