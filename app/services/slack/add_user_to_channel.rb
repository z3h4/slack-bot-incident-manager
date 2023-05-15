module Slack
  class AddUserToChannel < ApplicationService
    def initialize(user_id, channel_id)
      @user_id = user_id
      @channel_id = channel_id
    end

    def call
      client = Slack::Web::Client.new

      begin
        client.conversations_invite(channel: @channel_id, users: @user_id)
      rescue Slack::Web::Api::Errors::SlackError => e
        raise IncidentManager::Error, e
      end
    end
  end
end
