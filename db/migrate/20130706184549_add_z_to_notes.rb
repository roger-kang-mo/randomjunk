class AddZToNotes < ActiveRecord::Migration
  def change
  	add_column :notes, :z, :integer
  end
end
