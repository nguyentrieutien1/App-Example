# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: {
    minimum: Settings["MIN_NAME_LENGTH"]
  }
  before_create :upcase_name
  validates :birthday, presence: true
  validate :birthday_within_last_100_years
  
  private
    
    def upcase_name
      self.name = name.upcase
    end
    
    def birthday_within_last_100_years
      return unless birthday.present? && birthday < Settings["HUNDRED_YEARS"].years.ago.to_date
      
      errors.add(:birthday, :birthday_error)
    end
end
