module Slack
  class PostResolveIncidentMessage < ApplicationService
    def initialize(channel_id, message)
      @channel_id = channel_id
      @message = message
    end

    def call
      slack_client.chat_postMessage(
        channel: @channel_id,
        text: "The incident was resolved in #{@message}."
      )
    end
  end
end
