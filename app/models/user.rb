class User < ApplicationRecord
  attr_accessor :remember_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_many :suggests, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_secure_password
  validates :name, presence: true, length: {maximum: Settings.user_models.max_length_name}
  validates :email, presence: true, length: {maximum: Settings.user_models.max_length_email},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.user_models.min_length_password}, allow_nil: true
  before_save :downcase_email

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
