class AddDataQualityToInteraction < ActiveRecord::Migration
  def change
    add_column :interactions, :data_quality, :integer, default: 2
    
    add_index :interactions, :data_quality
  end
end
