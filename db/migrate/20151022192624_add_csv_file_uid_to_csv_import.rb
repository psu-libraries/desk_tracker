class AddCSVFileUidToCSVImport < ActiveRecord::Migration
  def change
    add_column :csv_imports, :csv_file_uid, :string
  end
end
