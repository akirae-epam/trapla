# frozen_string_literal: true

class User < ApplicationRecord
  has_many :plans, dependent: :destroy, inverse_of: :user
  has_many :following_relationships, class_name: 'Relationship', # rubocop:disable Rails/InverseOf
                                     foreign_key: 'follower_id',
                                     dependent: :destroy
  has_many :follower_relationships, class_name: 'Relationship', # rubocop:disable Rails/InverseOf
                                    foreign_key: 'followed_id',
                                    dependent: :destroy
  has_many :following, through: :following_relationships,
                       source: :followed
  has_many :followers, through: :follower_relationships,
                       source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email, :save_user_image
  before_create :create_activation_digest

  # プロフィール画像
  has_one_attached :user_image
  attribute :new_user_image

  validates :name, presence: true,
                   length: { maximum: 25 },
                   uniqueness: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true,
                       length: { minimum: 6 },
                       allow_nil: true
  has_secure_password

  validate :picture_validation

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # アカウント有効化のメールを送信する
  def send_account_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # アカウントを有効化する
  def activate
    update(activated: true, activated_at: Time.zone.now)
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # 永続セッションのためにユーザーをデータベースremember_digestカラムに記憶する
  def cookie_remember
    self.remember_token = User.new_token
    update_columns(remember_digest: User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def token_authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def cookie_forget
    update_attribute(:remember_digest, nil)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    email.downcase!
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  # プロフィール画像がアップロードされたら変更する
  def save_user_image
    self.user_image = new_user_image if new_user_image
  end

  # アップロードされた画像のサイズをバリデーションする
  def picture_validation
    return unless new_user_image && new_user_image.size > 5.megabytes

    return errors.add(:new_user_image, 'should be less than 5MB')
  end
end
