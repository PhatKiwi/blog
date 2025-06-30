class Post < ApplicationRecord
  acts_as_taggable_on :tags
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  validates :title, presence: true
  validates :body, presence: true

  after_create_commit -> { broadcast_prepend_to "posts" }

  scope :published, -> { where(published: true) }

  def draft?
    !published?
  end

  def published?
    published
  end

  def liked_by?(user)
    return false unless user
    likes.exists?(user: user)
  end

  def likes_count
    likes.count
  end
end
