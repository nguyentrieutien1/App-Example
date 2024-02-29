# frozen_string_literal: true

class User < ApplicationRecord
  scope :sorted_by_name, -> { order(name: :asc) }
  has_secure_password
  attr_accessor :remember_token

  validates :name, presence: true, length: {
    minimum: Settings["MIN_NAME_LENGTH"]
  }
  before_create :upcase_name
  validates :birthday, presence: true
  validate :birthday_within_last_100_years, if: :birthday
  validates_confirmation_of :password_digest

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, digest(remember_token)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
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
