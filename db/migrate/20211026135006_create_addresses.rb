class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.citext :address_line_1
      t.citext :address_line_2
      t.citext :suburb
      t.citext :post_code
      t.citext :state
      t.citext :country
      t.references :addressable, polymorphic: true
      t.timestamps
    end
  end
end
