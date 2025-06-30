class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true

  has_many :posts
  has_many :comments
  has_many :likes, dependent: :destroy
  has_one_attached :avatar

  after_commit :add_default_avatar, on: [:create, :update]

  def avatar_thumbnail
    avatar.variant(resize_to_limit: [150, 150]).processed
  end

  private

  def add_default_avatar
    return if avatar.attached?
    avatar.attach(
      io: File.open(Rails.root.join('app', 'assets', 'images', 'default_user_avatar.jpg')),
      filename: 'default_user_avatar.jpg',
      content_type: 'image/jpg'
    )
  end
end
