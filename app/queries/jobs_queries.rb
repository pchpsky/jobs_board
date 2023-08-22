class JobsQueries
  def jobs_with_status
    job_events =
      Job::Event.select(%[
        job_events.*,
        ROW_NUMBER() OVER (PARTITION BY job_events.job_id ORDER BY job_events.created_at DESC) AS row_number
      ])

    Job
      .with(job_events:)
      .select('jobs.*')
      .select(%[
        COALESCE(CASE job_events.type
          WHEN 'Job::Event::Activated' THEN 'activated'
        END, 'deactivated') AS status
      ])
      .joins('LEFT JOIN job_events ON jobs.id = job_events.job_id AND job_events.row_number = 1')
  end

  def count_applications(job_application_statuses:)
    Job
      .with(job_application_statuses:)
      .select(%[
        COUNT(CASE status WHEN 'hired' THEN 1 END) AS hired_candidates_count,
        COUNT(CASE status WHEN 'rejected' THEN 1 END) AS rejected_candidates_count,
        COUNT(CASE WHEN status = 'interview' OR status = 'applied' THEN 1 END) AS ongoing_candidates_count
      ])
      .joins('LEFT JOIN job_application_statuses ON jobs.id = job_application_statuses.job_id')
  end
end
