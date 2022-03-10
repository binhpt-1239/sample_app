class Micropost < ApplicationRecord
  belongs_to :user
  scope :new_post, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.digit_140}
  validate  :picture_size

  private

  def picture_size
    errors.add(:picture, Settings.less_than_5MB) if picture.size > 5.megabytes
  end
end
