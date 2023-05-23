module Slack
  class SetChannelDescription < ApplicationService
    attr_reader :channel_id, :description, :slack_client

    def initialize(channel_id, description, slack_client)
      super()
      @channel_id = channel_id
      @description = description
      @slack_client = slack_client
    end

    def call
      slack_client.conversations_setPurpose(channel: channel_id, purpose: description)
    end
  end
end
