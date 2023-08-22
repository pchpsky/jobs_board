Rails.application.routes.draw do
  scope :jobs do
    get '/', to: 'jobs#index'
  end

  scope :job_applications do
    get '/', to: 'job_applications#index'
  end
end
