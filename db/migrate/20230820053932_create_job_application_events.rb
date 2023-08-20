class CreateJobApplicationEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :job_application_events do |t|
      t.string :type
      t.references :job_application, null: false, foreign_key: true
      t.jsonb :data, null: false, default: {}

      t.timestamps
    end

    add_index :job_application_events, :type
  end
end
