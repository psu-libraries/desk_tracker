class AddProgressAndStatusToImports < ActiveRecord::Migration
  def change
    add_column :csv_imports, :progress, :integer, default: 0
    add_column :csv_imports, :status, :string
    add_column :csv_imports, :time_completed, :datetime
    
    add_index :csv_imports, :status
  end
end
