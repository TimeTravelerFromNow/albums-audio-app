class Music < ApplicationRecord
  has_one_attached :music_file
  has_one_attached :single_cover_image
  has_many :elements
  belongs_to :album, optional: true

  def single?
    return :album_id == nil
  end

end
