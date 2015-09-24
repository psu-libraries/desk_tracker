class CreateCSVImports < ActiveRecord::Migration
  def change
    create_table :csv_imports do |t|
      t.string :file_name, null: false
      t.integer :file_size
      t.integer :row_count

      t.timestamps null: false
    end
    
    add_index :csv_imports, :file_name
  end
end
