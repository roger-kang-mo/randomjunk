class CreateMinesweeperRecordsTable < ActiveRecord::Migration
  def change
  	create_table :minesweeper_records do |t|
  		t.integer :time
  	end
  end
end
