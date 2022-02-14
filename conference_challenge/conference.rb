# frozen_string_literal: true

require_relative 'scheduler'
require_relative 'talk'

class Conference
  MORNING_SESSION_START_TIME = '9 AM'
  MORNING_SESSION_END_TIME = '12 PM'
  AFTERNOON_SESSION_START_TIME = '1 PM'
  AFTERNOON_SESSION_END_TIME = '5 PM'
  TOTAL_TRACKS = 2
  LIGHTNING_TALK_DURATION = 5 # minutes

  TALKS = [{ title: 'Pryin open the black box', duration: 60 },
           { title: 'Migrating a huge production codebase from sinatra to Rails', duration: 45 },
           { title: 'How does bundler work', duration: 30 },
           { title: 'Sustainable Open SourcePryin open the black box', duration: 45 },
           { title: 'How to program with Accessiblity in Mind', duration: 45 },
           { title: 'Riding Rails for 10 years', type: 'Lightining' },
           { title: 'Implementing a strong code review culture', duration: 60 },
           { title: 'Scaling Rails for Black Friday', duration: 45 },
           { title: "Docker isn't just for deployment", duration: 30 },
           { title: 'Callbacks in Rails', duration: 30 },
           { title: 'Microservices, a bittersweet symphony', duration: 45 },
           { title: 'Teaching github for poets', duration: 60 },
           { title: 'Test Driving your Rails Infrastucture with Chef', duration: 60 },
           { title: 'SVG charts and graphics with Ruby', duration: 45 },
           { title: 'Interviewing like a unicorn: How Great Teams Hire', duration: 30 },
           { title: 'How to talk to humans: a different approach to soft skills', duration: 30 },
           { title: 'Getting a handle on Legacy Code', duration: 60 },
           { title: 'Heroku: A year in review', duration: 30 },
           { title: 'Ansible : An alternative to chef', type: 'Lightining' },
           { title: 'Ruby on Rails on Minitest', duration: 30 }].freeze

  def schedule_talks
    @scheduler = Scheduler.new(talks)
    @scheduler.schedule_talks
  end

  def print_slots
    @scheduler.tracks.each_with_index do |room, index|
      puts "\nTrack #{index + 1}"
      room.each do |talk|
        puts "#{in_hours_and_minutes(talk.slot)} #{talk.title} #{talk.duration} minutes"
      end
    end
  end

  private

  def talks
    TALKS.map { |talk| Talk.new(talk[:title], talk_duration(talk), talk[:type]) }
  end

  def talk_duration(talk)
    talk[:duration] || LIGHTNING_TALK_DURATION
  end

  def in_hours_and_minutes(minutes)
    hours = minutes / 60
    minutes = minutes % 60
    time = Time.parse("#{hours}:#{minutes}")
    time.strftime('%I:%M %p')
  end
end
