class CreateItem < ActiveRecord::Migration
  def up
  	create_table :items do |t|
  		t.string :title
  		t.text :description
  		t.boolean :is_done, default: false
      t.timestamps
  	end 
  end

  def down
  	drop_table :items
  end
end
