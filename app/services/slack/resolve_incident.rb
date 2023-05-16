module Slack
  class ResolveIncident < ApplicationService
    def initialize(channel_id)
      @channel_id = channel_id
    end

    def call
      incident = Incident.find_by(channel_id: @channel_id)
      incident.resolve!

      formatted_time_difference = CalculateTimeDifference.call(incident)
      PostResolveIncidentMessage.call(@channel_id, formatted_time_difference)
    end
  end
end
