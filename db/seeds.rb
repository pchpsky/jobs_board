# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

job1, job2 = Job.create([
                          {
                            title: 'Software Engineer',
                            description: 'We are looking for a software engineer to join our team.'
                          },
                          {
                            title: 'Frontend Engineer',
                            description: 'We are looking for a frontend engineer to join our team.'
                          }
                        ])

job1_applications = job1.job_applications.create([
                                                   { candidate_name: 'John Doe' },
                                                   { candidate_name: 'Jane Doe' }
                                                 ])

job2_applications = job2.job_applications.create([
                                                   { candidate_name: 'John Smith' },
                                                   { candidate_name: 'Jane Smith' },
                                                   { candidate_name: 'John Doe' }
                                                 ])

# activated
job1.events.create([
                     { type: 'Job::Event::Activated' }
                   ])

# activated and deactivated
job2.events.create([
                     { type: 'Job::Event::Activated' },
                     { type: 'Job::Event::Deactivated' }
                   ])

# hired
job1_applications.first.events.create([
                                        { type: 'JobApplication::Event::Interview',
                                          data: { interviewed_at: 1.day.ago } },
                                        { type: 'JobApplication::Event::Note',
                                          data: { content: 'This candidate is great!' } },
                                        { type: 'JobApplication::Event::Hired', data: { hired_at: 1.day.ago } }
                                      ])
# rejected
job1_applications.second.events.create([
                                         { type: 'JobApplication::Event::Interview',
                                           data: { interviewed_at: 2.days.ago } },
                                         { type: 'JobApplication::Event::Note',
                                           data: { content: 'This candidate is not great.' } },
                                         { type: 'JobApplication::Event::Rejected', data: { rejected_at: 1.day.ago } }
                                       ])

# job2_applications.first interviewed
job2_applications.first.events.create([
                                        { type: 'JobApplication::Event::Interview',
                                          data: { interviewed_at: 1.day.ago } },
                                        { type: 'JobApplication::Event::Note',
                                          data: { content: 'This candidate is great!' } }
                                      ])
# job2_applications.second rejected
job2_applications.second.events.create([
                                         { type: 'JobApplication::Event::Interview',
                                           data: { interviewed_at: 2.days.ago } },
                                         { type: 'JobApplication::Event::Note',
                                           data: { content: 'This candidate is not great.' } },
                                         { type: 'JobApplication::Event::Rejected', data: { rejected_at: 1.day.ago } }
                                       ])
# job2_applications.third applied
