require 'string_utils'

class CalculateTimeDifference < ApplicationService
  def initialize(incident)
    @incident = incident
  end

  def call
    created_at = @incident.created_at
    resolved_at = @incident.resolved_at
    time_difference = (resolved_at - created_at).to_i

    days = time_difference / (24 * 3600)
    hours = (time_difference % (24 * 3600)) / 3600
    minutes = (time_difference % 3600) / 60
    seconds = time_difference % 60

    duration = ''
    duration += "#{days} #{StringUtils.pluralize(days, 'day')} " if days.positive?
    duration += "#{hours} #{StringUtils.pluralize(hours, 'hour')} " if hours.positive?
    duration += "#{minutes} #{StringUtils.pluralize(minutes, 'minute')} " if minutes.positive?
    duration += "#{seconds} #{StringUtils.pluralize(seconds, 'second')} " if seconds.positive?
    duration.rstrip
  end
end
