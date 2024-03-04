# frozen_string_literal: true

class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :content, presence: true, length: { maximum: Settings["DIGIT_140"] }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png], message: I18n.t("image.valid_message") }
  scope :recent_posts, -> { order created_at: :desc }
end
