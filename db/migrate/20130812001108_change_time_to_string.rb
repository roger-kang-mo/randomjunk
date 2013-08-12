class ChangeTimeToString < ActiveRecord::Migration
  def change
  	change_column :minesweeper_records, :time, :string
  end
end
