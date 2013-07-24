class AddApprovedToThought < ActiveRecord::Migration
  def change
  	add_column :thoughts, :approved, :boolean
  end
end
