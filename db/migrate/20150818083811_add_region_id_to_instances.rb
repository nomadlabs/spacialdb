class AddRegionIdToInstances < ActiveRecord::Migration
  def change
    add_column :instances, :region_id, :integer
  end
end
