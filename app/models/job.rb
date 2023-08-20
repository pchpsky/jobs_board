class Job < ApplicationRecord
  has_many :job_applications, dependent: :destroy
  has_many :events, dependent: :destroy, class_name: 'Job::Event'
end
