class AddGridToBoard < ActiveRecord::Migration[7.0]
  def change
    change_table :boards do |t|
      # postgres stores boolean as a byte to accommodate NULL
      # A bit wasteful for our purpose, but simpler than
      # bit-twiddling a binary type as a bitmask
      t.boolean :grid, array: true, default: []
    end
  end
end
