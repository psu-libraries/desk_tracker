class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      
      t.integer :response_set
      t.integer :response_id, null: false
      t.integer :parent_response_id
      t.datetime :date_time
      t.string :page
      t.string :question
      t.string :response
      t.string :optional_text
      t.string :user
      t.string :branch
      t.string :desk
      t.string :library

      t.timestamps null: false
    end
    
    add_index :interactions, :response_id, unique: true
    add_index :interactions, :page
    add_index :interactions, :user
  end
end
