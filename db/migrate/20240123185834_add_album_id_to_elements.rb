class AddAlbumIdToElements < ActiveRecord::Migration[7.0]
  def change
    add_column :elements, :album_id, :integer
  end
end
