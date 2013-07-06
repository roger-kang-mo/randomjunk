class AddPositionsToNotes < ActiveRecord::Migration
  def change
  	add_column :notes, :x, :integer
  	add_column :notes, :y, :integer
  	add_column :notes, :size, :integer
  end
end
