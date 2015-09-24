class AddColumnsAndIndexToDelayedJobs < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :resource_id, :integer
    add_column :delayed_jobs, :resource_class, :string
    add_column :delayed_jobs, :resource_data, :string
    
    add_index :delayed_jobs, :queue
    add_index :delayed_jobs, :resource_id
    add_index :delayed_jobs, :resource_class
  end
end
