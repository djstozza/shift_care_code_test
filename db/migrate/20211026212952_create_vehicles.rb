class CreateVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicles do |t|
      t.references :plumber, index: true
      t.citext :make, null: false
      t.citext :model, null: false
      t.citext :other_make
      t.integer :year, null: false
      t.citext :number_plate, null: false
      t.timestamps
    end

    add_index :vehicles, :number_plate, unique: true
  end
end
