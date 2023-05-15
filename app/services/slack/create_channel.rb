module Slack
  class CreateChannel < ApplicationService
    def initialize(name, team_id)
      @name = name
      @team_id = team_id
    end

    def call
      client = Slack::Web::Client.new
      format_slack_channel_name

      begin
        response = client.conversations_create(name: @name, is_private: true, team_id: @team_id)
        return response if response['ok']
      rescue Slack::Web::Api::Errors::SlackError => e
        raise IncidentManager::Error, e
      end
    end

    private

    def format_slack_channel_name
      @name = @name.downcase.gsub(/[^a-z0-9_-]+/, '-')
      @name = @name.gsub(/^-+|-+$/, '')
      @name = @name[0..79]
    end
  end
end
