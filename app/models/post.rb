class Post < ApplicationRecord
  acts_as_taggable_on :tags
  belongs_to :user
  has_many :comments, dependent: :destroy

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
end
