class JobApplication::Event::Hired < JobApplication::Event
  store_accessor :data, :hired_at

  validates :hired_at, presence: true

  def hired_at
    super&.to_datetime
  end

  def hired_at=(val)
    super(val&.to_datetime)
  end
end
