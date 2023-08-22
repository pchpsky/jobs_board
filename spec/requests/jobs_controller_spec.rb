require 'rails_helper'

RSpec.describe 'JobsControllers', type: :request do
  describe 'GET /jobs' do
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
    let!(:job3) do
      Job.create!(title: 'Frontend Engineer', description: 'We are looking for a frontend engineer to join our team.')
    end
    let!(:job1_hired) { JobApplication.create!(job: job1, candidate_name: 'John Doe') }
    let!(:job1_applied) { JobApplication.create!(job: job1, candidate_name: 'Jane Doe') }
    let!(:job2_rejected) { JobApplication.create!(job: job2, candidate_name: 'Jane Doe') }
    let!(:job2_interview) { JobApplication.create!(job: job2, candidate_name: 'John Smith') }
    let!(:job2_applied) { JobApplication.create!(job: job2, candidate_name: 'John Doe') }
    let!(:job3_applied) { JobApplication.create!(job: job3, candidate_name: 'John Doe') }

    before do
      activate_job(job1)
      activate_job(job2)

      JobApplication::Event::Hired.create!(job_application: job1_hired, hired_at: Time.parse('2023-01-02'))

      JobApplication::Event::Rejected.create!(job_application: job2_rejected)

      JobApplication::Event::Interview.create!(job_application: job2_interview,
                                               interviewed_at: Time.parse('2023-01-01'))
    end

    it 'returns all jobs with their status' do
      get '/jobs'

      expect(JSON.parse(response.body)).to contain_exactly(
        a_hash_including('id' => job1.id, 'title' => job1.title, 'description' => job1.description,
                         'status' => 'activated'),
        a_hash_including('id' => job2.id, 'title' => job2.title, 'description' => job2.description,
                         'status' => 'activated'),
        a_hash_including('id' => job3.id, 'title' => job3.title, 'description' => job3.description,
                         'status' => 'deactivated')
      )
    end

    it 'returns number of hired candidates' do
      get '/jobs'

      expect(JSON.parse(response.body)).to contain_exactly(
        a_hash_including('id' => job1.id, 'hired_candidates_count' => 1),
        a_hash_including('id' => job2.id, 'hired_candidates_count' => 0),
        a_hash_including('id' => job3.id, 'hired_candidates_count' => 0)
      )
    end

    it 'returns number of rejected candidates' do
      get '/jobs'

      expect(JSON.parse(response.body)).to contain_exactly(
        a_hash_including('id' => job1.id, 'rejected_candidates_count' => 0),
        a_hash_including('id' => job2.id, 'rejected_candidates_count' => 1),
        a_hash_including('id' => job3.id, 'rejected_candidates_count' => 0)
      )
    end

    it 'returns number of ongoing candidates' do
      get '/jobs'

      expect(JSON.parse(response.body)).to contain_exactly(
        a_hash_including('id' => job1.id, 'ongoing_candidates_count' => 1),
        a_hash_including('id' => job2.id, 'ongoing_candidates_count' => 2),
        a_hash_including('id' => job3.id, 'ongoing_candidates_count' => 1)
      )
    end
  end
end
