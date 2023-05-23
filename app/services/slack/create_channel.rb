module Slack
  class CreateChannel < ApplicationService
    attr_reader :name, :team_id, :slack_client

    def initialize(name, team_id, slack_client)
      super()
      @name = name
      @team_id = team_id
      @slack_client = slack_client
    end

    def call
      format_slack_channel_name
      create_slack_channel
    end

    private

    def format_slack_channel_name
      @name = name.downcase.gsub(/[^a-z0-9_-]+/, '-').gsub(/^-+|-+$/, '')[0..79]
    end

    def create_slack_channel
      response = slack_client.conversations_create(name:, is_private: true, team_id:)
      return response if response['ok']
    rescue Slack::Web::Api::Errors::SlackError => e
      raise IncidentManager::Error, e
    end
  end
end
