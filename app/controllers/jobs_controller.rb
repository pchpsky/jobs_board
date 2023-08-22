class JobsController < ApplicationController
  def index
    render json: jobs.map { |job| job_attributes(job) }
  end

  private

  def jobs
    jobs_queries = JobsQueries.new
    job_application_queries = JobApplicationsQueries.new
    count_applications_query = jobs_queries.count_applications(job_application_statuses: job_application_queries.job_application_statuses)

    jobs_queries
      .jobs_with_status
      .merge(count_applications_query)
      .group('jobs.id', 'job_events.type')
  end

  def job_attributes(job)
    job.attributes.slice(
      'id',
      'title',
      'description',
      'status',
      'hired_candidates_count',
      'rejected_candidates_count',
      'ongoing_candidates_count'
    )
  end
end
