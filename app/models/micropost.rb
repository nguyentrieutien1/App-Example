# frozen_string_literal: true

class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :content, presence: true, length: { maximum: Settings["DIGIT_140"] }

  scope :recent_posts, -> { order created_at: :desc }
end
