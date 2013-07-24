class AddPasscodeToComments < ActiveRecord::Migration
  def change
  	add_column :comments, :passcode, :string
  end
end
