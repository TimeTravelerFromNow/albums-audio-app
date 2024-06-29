class AddPositionToMusics < ActiveRecord::Migration[7.0]
  def change
    add_column :musics, :position, :integer
  end
end
