class AddIndexToBoards < ActiveRecord::Migration[7.0]
  def change
    add_index :boards, :created_at, order: {created_at: :desc}
  end
end
