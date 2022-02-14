# frozen_string_literal: true

require_relative './conference'

conference = Conference.new
conference.schedule_talks
conference.print_slots
