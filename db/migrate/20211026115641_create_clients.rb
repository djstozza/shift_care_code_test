class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.citext :email, null: false
      t.citext :first_name, null: false
      t.citext :last_name, null: false
      t.date :date_of_birth, null: false
      t.string :private_note
      t.timestamps
    end

    add_index :clients, :email, unique: true
  end
end
