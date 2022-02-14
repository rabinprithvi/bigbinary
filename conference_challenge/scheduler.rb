# frozen_string_literal: true

require 'time'
require_relative './conference'

class Scheduler
  attr_reader :tracks

  def initialize(talks)
    @all_talks = talks
    @total_tracks = Conference::TOTAL_TRACKS
    @tracks = create_tracks

    @lightning_talks_duration = Conference::LIGHTNING_TALK_DURATION

    @lightning_talks = lightning_talks
    @regular_talks = regular_talks

    @morning_session_start_time = in_minutes(Conference::MORNING_SESSION_START_TIME)
    @morning_session_end_time = in_minutes(Conference::MORNING_SESSION_END_TIME)
    @afternoon_session_start_time = in_minutes(Conference::AFTERNOON_SESSION_START_TIME)
    @afternoon_session_end_time = in_minutes(Conference::AFTERNOON_SESSION_END_TIME)
  end

  # To make use of tracks effienciently we could first allot morning session for all the tracks
  # Followed by aftenoon slots and finally Lightning slots
  def schedule_talks
    schedule_slots(@morning_session_start_time, @morning_session_end_time)
    schedule_slots(@afternoon_session_start_time, @afternoon_session_end_time)
    schedule_lightning_talks
  end

  private

  def create_tracks
    @total_tracks.times.map { |_track| [] }
  end

  def schedule_slots(start_time, end_time)
    @total_tracks.times do |index|
      schedule(start_time, end_time, index)
    end
  end

  # Lightning slots could be alloted in a room where slots complete first
  def schedule_lightning_talks
    current_track = first_of_last_talk.track
    current_time = first_of_last_talk.slot + first_of_last_talk.duration

    @lightning_talks.each do |talk|
      talk.slot = current_time
      talk.duration = @lightning_talks_duration
      @tracks[current_track] << talk
      current_time += @lightning_talks_duration
    end
  end

  def schedule(current_time, session_end_time, current_track)
    unscheduled_talks.each do |talk|
      talk_end_time = current_time + talk.duration
      next unless talk_end_time <= session_end_time

      talk.slot = current_time
      talk.track = current_track
      @tracks[current_track] << talk
      current_time = talk_end_time
    end
  end

  def in_minutes(time_string)
    Time.parse(time_string).hour * 60
  end

  def unscheduled_talks
    @regular_talks - @tracks.flatten
  end

  def lightning_talks
    @all_talks.reject { |talk| talk.type.nil? }
  end

  def regular_talks
    @all_talks - @lightning_talks
  end

  def last_talks
    @tracks.map(&:last)
  end

  def first_of_last_talk
    last_talks.min_by(&:duration)
  end
end
