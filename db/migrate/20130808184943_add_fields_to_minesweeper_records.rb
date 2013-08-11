class AddFieldsToMinesweeperRecords < ActiveRecord::Migration
  def change
  	add_column :minesweeper_records, :name, :string
  	add_column :minesweeper_records, :width, :integer
  	add_column :minesweeper_records, :height, :integer
  	add_column :minesweeper_records, :mines, :integer
  end
end
