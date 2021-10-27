class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.belongs_to :client, index: true
      t.boolean :done, default: false, null: false
      t.timestamps
    end
  end
end
