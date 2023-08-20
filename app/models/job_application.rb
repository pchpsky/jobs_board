class JobApplication < ApplicationRecord
  belongs_to :job
  has_many :events, dependent: :destroy, class_name: 'JobApplication::Event'
end
