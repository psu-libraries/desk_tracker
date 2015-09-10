class AddCountDateToInteraction < ActiveRecord::Migration
  def change
    add_column :interactions, :count_date, :date
    
    add_index :interactions, :date_time
    add_index :interactions, :count_date
  end
end
