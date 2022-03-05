class User < ApplicationRecord
  attr_accessor :remember_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  before_save{email.downcase!}
  validates :name, presence: true
  validates :email, presence: true, length: {maximum: Settings.digit_255},
                  format: {with: VALID_EMAIL_REGEX},
                  uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.digit_6}
  has_secure_password

  def self.digest string
    min_cost = BCrypt::Engine::MIN_COST
    cost = ActiveModel::SecurePassword.min_cost ? min_cost : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end
end
