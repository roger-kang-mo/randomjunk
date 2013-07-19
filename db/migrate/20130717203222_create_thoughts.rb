class CreateThoughts < ActiveRecord::Migration
  def change
  	create_table :thoughts do |t|
  		t.text :content
  		t.timestamp :created_at
  		t.integer :thumbs
  	end
  end
end
