class JobApplication::Event::Interview < JobApplication::Event
  store_accessor :data, :interviewed_at

  validates :interviewed_at, presence: true

  def interviewed_at
    super&.to_datetime
  end

  def interviewed_at=(val)
    super(val&.to_datetime)
  end
end
