class CreateJobApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :job_applications do |t|
      t.references :job, null: false, foreign_key: true
      t.string :candidate_name

      t.timestamps
    end
  end
end
