module Slack
  class SetChannelDescription < ApplicationService
    def initialize(channel_id, description)
      @channel_id = channel_id
      @description = description
    end

    def call
      slack_client.conversations_setPurpose(channel: @channel_id, purpose: @description)
    end
  end
end
