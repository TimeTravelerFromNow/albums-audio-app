class CreateElements < ActiveRecord::Migration[7.0]
  def change
    create_table :elements do |t|
      t.string :kind
      t.string :ext_link
      t.integer :blog_post_id
      t.integer :position

      t.timestamps
    end
  end
end
