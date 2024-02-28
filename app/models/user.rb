# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  attr_accessor :remember_token, :activation_token

  validates :name, presence: true, length: {
    minimum: Settings["MIN_NAME_LENGTH"]
  }
  validates :birthday, presence: true
  validate :birthday_within_last_100_years, if: :birthday
  validates_confirmation_of :password_digest

  before_create :create_activation_digest

  scope :sorted_by_name, -> { order :name }

  def active
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = digest activation_token
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, digest(remember_token)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(attribute, token)
    digest_num = send("#{attribute}_digest")
    return false unless digest_num.present?

    bcrypt_password = BCrypt::Password.new digest_num
    bcrypt_password === token
  end

  def forget
    update_column :remember_digest, nil
  end

  private

  def upcase_name
    self.name = name.upcase
  end

  def birthday_within_last_100_years
    return if birthday > Settings["HUNDRED_YEARS"].years.ago.to_date

    errors.add(:birthday, :birthday_error)
  end

  def digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, { cost: })
  end
end
