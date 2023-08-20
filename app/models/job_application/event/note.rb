class JobApplication::Event::Note < JobApplication::Event
  store_accessor :data, :content

  validates :content, presence: true
end
