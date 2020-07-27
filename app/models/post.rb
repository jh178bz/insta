class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :comments, dependent: :destroy

  validates :user_id, presence: true
  default_scope -> { order(created_at: :desc) }
  scope :search_by_keyword, -> (keyword) {
    where("posts.content LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present?}

  validates :image,presence:true, content_type: { in: %w[image/jpeg image/png],
                                       message: "must be a valid image format" },
                               size:{less_than: 5.megabytes,
                                       message: "should be less than 5MB" }

  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(resize_to_fill: [200, 200])
  end
end
