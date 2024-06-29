class Category < ApplicationRecord

  has_one_attached :category_image
  has_many :blog_posts
end
