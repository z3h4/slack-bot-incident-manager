module Slack
  class PostResolveIncidentMessage < ApplicationService
    attr_reader :channel_id, :message, :slack_client

    def initialize(channel_id, message, slack_client)
      @channel_id = channel_id
      @message = message
      @slack_client = slack_client
    end

    def call
      slack_client.chat_postMessage(
        channel: @channel_id,
        text: "The incident was resolved in #{@message}."
      )
    end
  end
end
