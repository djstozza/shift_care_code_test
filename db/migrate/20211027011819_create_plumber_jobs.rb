class CreatePlumberJobs < ActiveRecord::Migration[6.0]
  def change
    create_join_table :plumbers, :jobs do |t|
      t.index :plumber_id
      t.index :job_id
    end
  end
end
