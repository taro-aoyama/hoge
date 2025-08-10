class AddWaitlistRankToReservations < ActiveRecord::Migration[7.2]
  def change
    add_column :reservations, :waitlist_rank, :integer
  end
end
