class CreateComment < ActiveRecord::Migration
  def up
  	create_table :comments do |t|
  		t.text :body
  		t.references :item
  		t.timestamps
  	end 
  end

  def down
  	drop_table :comments
  end
end
