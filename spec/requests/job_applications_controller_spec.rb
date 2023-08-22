require 'rails_helper'

RSpec.describe 'JobApplicationsControllers', type: :request do
  describe 'GET /job_applications' do
    def activate_job(job)
      Job::Event::Activated.create!(job:)
    end

    # TODO: Refactor this to use factories
    let!(:job1) do
      Job.create!(title: 'Frontend Engineer', description: 'We are looking for a frontend engineer to join our team.')
    end
    let!(:job2) do
      Job.create!(title: 'Backend Engineer', description: 'We are looking for a backend engineer to join our team.')
    end
    let!(:inactive_job) do
      Job.create!(title: 'Frontend Engineer', description: 'We are looking for a frontend engineer to join our team.')
    end
    let!(:job1_hired) { JobApplication.create!(job: job1, candidate_name: 'John Doe') }
    let!(:job1_applied) { JobApplication.create!(job: job1, candidate_name: 'Jane Doe') }
    let!(:job2_rejected) { JobApplication.create!(job: job2, candidate_name: 'Jane Doe') }
    let!(:job2_interview) { JobApplication.create!(job: job2, candidate_name: 'John Smith') }
    let!(:inactive_job_application) { JobApplication.create!(job: inactive_job, candidate_name: 'John Doe') }

    before do
      activate_job(job1)
      activate_job(job2)

      JobApplication::Event::Interview.create!(job_application: job1_hired, interviewed_at: Time.parse('2023-01-01'))
      JobApplication::Event::Note.create!(job_application: job1_hired, content: 'This is a note')
      JobApplication::Event::Note.create!(job_application: job1_hired, content: 'This is another note')
      JobApplication::Event::Hired.create!(job_application: job1_hired, hired_at: Time.parse('2023-01-02'))

      JobApplication::Event::Note.create!(job_application: job1_applied, content: 'This is a note')

      JobApplication::Event::Interview.create!(job_application: job2_rejected, interviewed_at: Time.parse('2023-01-01'))
      JobApplication::Event::Rejected.create!(job_application: job2_rejected)

      JobApplication::Event::Interview.create!(job_application: job2_interview,
                                               interviewed_at: Time.parse('2023-01-01'))
    end

    it 'returns only applications to active jobs' do
      get '/job_applications'

      expect(JSON.parse(response.body)).to contain_exactly(
        a_hash_including('id' => job1_hired.id, 'job_id' => job1.id),
        a_hash_including('id' => job1_applied.id, 'job_id' => job1.id),
        a_hash_including('id' => job2_rejected.id, 'job_id' => job2.id),
        a_hash_including('id' => job2_interview.id, 'job_id' => job2.id)
      )
    end

    it 'returns name of the candidate for each application' do
      get '/job_applications'

      expect(JSON.parse(response.body)).to contain_exactly(
        a_hash_including('id' => job1_hired.id, 'candidate_name' => 'John Doe'),
        a_hash_including('id' => job1_applied.id, 'candidate_name' => 'Jane Doe'),
        a_hash_including('id' => job2_rejected.id, 'candidate_name' => 'Jane Doe'),
        a_hash_including('id' => job2_interview.id, 'candidate_name' => 'John Smith')
      )
    end

    it 'returns job title for each application' do
      get '/job_applications'

      expect(JSON.parse(response.body)).to contain_exactly(
        a_hash_including('id' => job1_hired.id, 'job_title' => job1.title),
        a_hash_including('id' => job1_applied.id, 'job_title' => job1.title),
        a_hash_including('id' => job2_rejected.id, 'job_title' => job2.title),
        a_hash_including('id' => job2_interview.id, 'job_title' => job2.title)
      )
    end

    it 'returns status for each application' do
      get '/job_applications'

      expect(JSON.parse(response.body)).to contain_exactly(
        a_hash_including('id' => job1_hired.id, 'status' => 'hired'),
        a_hash_including('id' => job1_applied.id, 'status' => 'applied'),
        a_hash_including('id' => job2_rejected.id, 'status' => 'rejected'),
        a_hash_including('id' => job2_interview.id, 'status' => 'interview')
      )
    end

    it 'returns number of notes for each application' do
      get '/job_applications'

      expect(JSON.parse(response.body)).to contain_exactly(
        a_hash_including('id' => job1_hired.id, 'notes_count' => 2),
        a_hash_including('id' => job1_applied.id, 'notes_count' => 1),
        a_hash_including('id' => job2_rejected.id, 'notes_count' => 0),
        a_hash_including('id' => job2_interview.id, 'notes_count' => 0)
      )
    end

    it 'returns first interview date for each application' do
      get '/job_applications'

      expect(JSON.parse(response.body)).to contain_exactly(
        a_hash_including('id' => job1_hired.id, 'first_interviewed_at' => '2023-01-01T00:00:00.000Z'),
        a_hash_including('id' => job1_applied.id, 'first_interviewed_at' => nil),
        a_hash_including('id' => job2_rejected.id, 'first_interviewed_at' => '2023-01-01T00:00:00.000Z'),
        a_hash_including('id' => job2_interview.id, 'first_interviewed_at' => '2023-01-01T00:00:00.000Z')
      )
    end
  end
end
