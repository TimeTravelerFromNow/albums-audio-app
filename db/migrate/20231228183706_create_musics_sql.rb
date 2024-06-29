class CreateMusicsSql < ActiveRecord::Migration[7.0]
  def change
    create_table :musics do |t|
      t.string :name
      t.integer :album_id
      t.timestamps
    end
  end
end
