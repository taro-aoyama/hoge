class CreateFacilityManagers < ActiveRecord::Migration[7.2]
  def change
    create_table :facility_managers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :facility, null: false, foreign_key: true

      t.timestamps
    end
  end
end
