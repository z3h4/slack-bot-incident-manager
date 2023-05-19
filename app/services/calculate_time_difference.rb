require 'string_utils'

class CalculateTimeDifference < ApplicationService
  def initialize(incident)
    @incident = incident
  end

  def call
    time_difference = calculate_time_difference(@incident.created_at, @incident.resolved_at)
    format_time_difference(time_difference)
  end

  private

  def calculate_time_difference(start_time, end_time)
    time_difference = (end_time - start_time).to_i

    {
      days: time_difference / (24 * 3600),
      hours: (time_difference % (24 * 3600)) / 3600,
      minutes: (time_difference % 3600) / 60,
      seconds: time_difference % 60
    }
  end

  def format_time_difference(time_difference)
    duration = ''
    duration += format_duration(time_difference[:days], 'day') if time_difference[:days].positive?
    duration += format_duration(time_difference[:hours], 'hour') if time_difference[:hours].positive?
    duration += format_duration(time_difference[:minutes], 'minute') if time_difference[:minutes].positive?
    duration += format_duration(time_difference[:seconds], 'second') if time_difference[:seconds].positive?
    duration.rstrip
  end

  def format_duration(value, unit)
    "#{value} #{StringUtils.pluralize(value, unit)} "
  end
end
