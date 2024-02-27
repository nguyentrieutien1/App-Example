# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: {
    minimum: Settings["MIN_NAME_LENGTH"]
  }
  before_create :upcase_name
  validates :birthday, presence: true
  validate :birthday_within_last_100_years, if: :birthday
  validates_confirmation_of :password_digest

  private

  def upcase_name
    self.name = name.upcase
  end

  def birthday_within_last_100_years
    return if birthday > Settings["HUNDRED_YEARS"].years.ago.to_date

    errors.add(:birthday, :birthday_error)
  end

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost
  end

  private_class_method :digest
end
