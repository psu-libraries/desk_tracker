class AddStateToCSVImport < ActiveRecord::Migration
  def change
    add_column :csv_imports, :stage, :string, default: 'initialized'
  end
end
