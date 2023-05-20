class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.string :name, limit: 160
      t.string :email, limit: 64
      t.integer :width
      t.integer :height
      t.integer :mines

      t.timestamps
    end
  end
end
