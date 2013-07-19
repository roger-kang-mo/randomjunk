class CreateComments < ActiveRecord::Migration
  def change
  	create_table :comments do |t|
  		t.text :author
  		t.text :content
  		t.timestamp :created_at
  		t.integer :thought_id
  	end
  end
end
