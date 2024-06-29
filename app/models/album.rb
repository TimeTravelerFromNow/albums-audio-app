class Album < ApplicationRecord

  validates :name, length: {minimum: 3}, allow_blank: false

  has_one_attached :album_cover_image
  has_many :musics

  has_rich_text :story
  has_many :elements, dependent: :destroy

  def to_param
    name
  end

  def header_img_url
    if album_cover_image.present?
      return album_cover_image
    end
    return ""
  end
end
