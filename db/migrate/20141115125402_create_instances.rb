class CreateInstances < ActiveRecord::Migration
  def change
    create_table(:instances, id: :uuid) do |t|
      t.belongs_to :user

      t.integer :droplet_id
      t.string :name
      t.string :status
      t.inet :ip_address

      t.timestamps null: false
    end
  end
end
