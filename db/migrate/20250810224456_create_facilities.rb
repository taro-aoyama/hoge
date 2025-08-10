class CreateFacilities < ActiveRecord::Migration[7.2]
  def change
    create_table :facilities do |t|
      t.string :name
      t.text :description
      t.string :location
      t.integer :capacity
      t.integer :hourly_rate
      t.boolean :active

      t.timestamps
    end
  end
end
