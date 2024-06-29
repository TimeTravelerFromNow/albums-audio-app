class AddCategoryIdToBlogPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :blog_posts, :category_id, :integer
  end
end
