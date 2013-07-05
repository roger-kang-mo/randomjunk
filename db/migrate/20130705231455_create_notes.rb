class CreateNotes < ActiveRecord::Migration
  def change
  	create_table :notes do |t|
  		t.text :content
  		t.string :author
  		t.timestamp :created_at
  	end
  end
end
