module Slack
  class ResolveIncident < ApplicationService
    attr_reader :channel_id, :slack_client

    def initialize(channel_id, slack_client)
      super()
      @channel_id = channel_id
      @slack_client = slack_client
    end

    def call
      incident = Incident.find_by(channel_id:)
      incident.resolve!

      formatted_time_difference = CalculateTimeDifference.call(incident)
      PostResolveIncidentMessage.call(channel_id, formatted_time_difference, slack_client)
    end
  end
end
