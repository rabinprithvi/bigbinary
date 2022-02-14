# frozen_string_literal: true

class Talk
  attr_accessor :title, :duration, :slot, :track, :type

  def initialize(title, duration, type)
    @title = title
    @duration = duration
    @type = type
  end
end
