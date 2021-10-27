class CreatePlumbers < ActiveRecord::Migration[6.0]
  def change
    create_table :plumbers do |t|
      t.citext :email, null: false
      t.citext :first_name, null: false
      t.citext :last_name, null: false
      t.timestamps
    end

    add_index :plumbers, :email, unique: true
  end
end
