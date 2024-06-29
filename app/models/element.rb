class Element < ApplicationRecord


  SPOTIFY_ASSET = "spotify-small.png"
  SOUNDCLOUD_ASSET = "soundcloud-orange.png"
  BANDCAMP_ASSET = "bandcamp-small.png"

  belongs_to :blog_post, optional: true
  belongs_to :album, optional: true

  validates :kind, inclusion: { in: ['paragraph', 'image', 'ext_link'] }
  has_rich_text :content
  has_one_attached :image

  def paragraph?
    kind == 'paragraph'
  end

  def image?
    kind == 'image'
  end

  def link?
    kind == 'ext_link'
  end

  def self.icon_path_for(position) # when we need a path for elements not yet set
    case position
    when 0
      return SPOTIFY_ASSET
    when 1
      return SOUNDCLOUD_ASSET
    when 2
      return BANDCAMP_ASSET
    else
      puts "/n/n/n #### /n NO ICON PATH FOR position #{position}. /n #### /n /n /n"
      return ""
    end # case position
  end # could be refactored into some sort of data structure,but it's fine here for now.

  def icon_path
    if self.link?
      case self.position
      when 0
        return SPOTIFY_ASSET
      when 1
        return SOUNDCLOUD_ASSET
      when 2
        return BANDCAMP_ASSET
      else
        puts "/n/n/n #### /n NO ICON PATH FOR element.position #{self.position}. /n #### /n /n /n"
        return ""
      end # case self.position
    else
      puts "/n/n/n #### /n TRIED TO GET ICON PATH FROM A NON- LINK TYPE. /n #### /n /n /n"
      return ""
    end
    return ""
  end

end
