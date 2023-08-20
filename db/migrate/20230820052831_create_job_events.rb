class CreateJobEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :job_events do |t|
      t.string :type
      t.references :job, null: false, foreign_key: true

      t.timestamps
    end

    add_index :job_events, :type
  end
end
