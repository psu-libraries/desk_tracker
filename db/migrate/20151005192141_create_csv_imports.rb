class CreateCSVImports < ActiveRecord::Migration
  def change
    create_table :csv_imports do |t|
      t.integer :file_size
      t.integer :row_count
      t.string :file_name, null: false
      t.integer :progress, default: 0

      t.timestamps null: false
    end
  end
end
