class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user

  validate :image_presence
  validates :title, presence: true, length: { maximum: 25 }
  validates :date, presence: true
  validates :size, numericality: { only_integer: true, greater_than: 0, less_than: 9999 }, :allow_blank => true
  validates :weight, numericality: { only_integer: true, greater_than: 0, less_than: 999999 }, :allow_blank => true
  validates :number, numericality: { only_integer: true, greater_than: 0, less_than: 9999 }, :allow_blank => true
  validates :comment, length: { maximum: 200 }

  scope :pager, ->(page: 1, per: 10) {
    num = page.to_i.positive? ? page.to_i - 1 : 0
    limit(per).offset(per * num)
  }

  def image_presence
    if image.attached?
      if !image.content_type.in?(%('image/jpeg image/png'))
        errors.add(:image, :jpeg_png_only)
      end
    else
      errors.add(:image, :image_blank)
    end
  end

end
