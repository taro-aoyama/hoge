class AddReservationTypeToReservations < ActiveRecord::Migration[7.2]
  def change
    add_column :reservations, :reservation_type, :integer, default: 0, null: false
  end
end
