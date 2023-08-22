class JobApplicationsQueries
  def select_status
    JobApplication
      .with(job_application_statuses:)
      .select('COALESCE(job_application_statuses.status, \'applied\') AS status')
      .joins('LEFT JOIN job_application_statuses ON job_applications.id = job_application_statuses.id')
  end

  def by_job_status(jobs_with_status:, status:)
    JobApplication
      .with(jobs: jobs_with_status)
      .joins(%(
        INNER JOIN jobs ON
          job_applications.job_id = jobs.id AND
          jobs.status = '#{JobApplication.sanitize_sql(status)}'
      ))
  end

  def select_notes_count
    notes_counts =
      JobApplication::Event::Note
      .select('job_application_id, count(*) as notes_count')
      .group(:job_application_id)

    JobApplication
      .with(notes_counts:)
      .select('COALESCE(notes_counts.notes_count, 0) AS notes_count')
      .joins('LEFT JOIN notes_counts ON job_applications.id = notes_counts.job_application_id')
  end

  def select_first_interviewed_at
    first_interviewes =
      JobApplication::Event::Interview
      .select(%[
          job_application_id,
          MIN(CAST(data->>\'interviewed_at\' AS TIMESTAMP)) as interviewed_at
        ])
      .group(:job_application_id)

    JobApplication
      .with(first_interviewes:)
      .select('first_interviewes.interviewed_at AS first_interviewed_at')
      .joins('LEFT JOIN first_interviewes ON job_applications.id = first_interviewes.job_application_id')
  end

  def job_application_statuses
    JobApplication
      .with(non_note_events:)
      .select('job_applications.*')
      .select(%[
        COALESCE(CASE non_note_events.type
          WHEN 'JobApplication::Event::Interview' THEN 'interview'
          WHEN 'JobApplication::Event::Hired' THEN 'hired'
          WHEN 'JobApplication::Event::Rejected' THEN 'rejected'
        END, 'applied') AS status
      ])
      .joins('LEFT JOIN non_note_events ON job_applications.id = non_note_events.job_application_id AND rank = 1')
  end

  private

  def non_note_events
    JobApplication::Event
      .where.not(type: JobApplication::Event::Note.name)
      .select(%[
        *,
        ROW_NUMBER() OVER (PARTITION BY job_application_id ORDER BY created_at DESC) AS rank
      ])
  end
end
