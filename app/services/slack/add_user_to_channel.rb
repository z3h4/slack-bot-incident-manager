module Slack
  class AddUserToChannel < ApplicationService
    attr_reader :user_id, :channel_id, :slack_client

    def initialize(user_id, channel_id, slack_client)
      super()
      @user_id = user_id
      @channel_id = channel_id
      @slack_client = slack_client
    end

    def call
      slack_client.conversations_invite(channel: @channel_id, users: @user_id)
    rescue Slack::Web::Api::Errors::SlackError => e
      raise IncidentManager::Error, e
    end
  end
end
