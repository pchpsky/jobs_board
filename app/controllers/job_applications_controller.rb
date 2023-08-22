class JobApplicationsController < ApplicationController
  def index
    render json: job_applications.map { |job_application| job_application_attributes(job_application) }
  end

  private

  def job_applications
    job_application_queries = JobApplicationsQueries.new
    job_queries = JobsQueries.new

    job_application_queries
      .by_job_status(jobs_with_status: job_queries.jobs_with_status, status: 'activated')
      .select('job_applications.*')
      .select('jobs.id AS job_id')
      .select('jobs.title AS job_title')
      .merge(job_application_queries.select_status)
      .merge(job_application_queries.select_notes_count)
      .merge(job_application_queries.select_first_interviewed_at)
  end

  def job_application_attributes(job_application)
    job_application
      .attributes
      .slice(
        'id',
        'job_id',
        'job_title',
        'candidate_name',
        'status',
        'notes_count',
        'first_interviewed_at'
      )
  end
end
