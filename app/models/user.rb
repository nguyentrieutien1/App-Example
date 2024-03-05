# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name, foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name, foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token, :reset_token

  validates :name, presence: true, length: {
    minimum: Settings["MIN_NAME_LENGTH"]
  }
  validates :birthday, presence: true
  validate :birthday_within_last_100_years, if: :birthday
  validates :password, presence: true
  validates_confirmation_of :password_digest

  before_create :create_activation_digest

  scope :sorted_by_name, -> { order :name }

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  def feed
    Micropost.relate_post(following_ids << id)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: digest(reset_digest), reset_sent_at: Time.zone.now
  end

  def password_reset_expired?
    reset_sent_at < Settings["EXPIRED_TIME_RESET_PASSWORD"].minutes.ago
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

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
