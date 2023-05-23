module Slack
  class CreateIncident < ApplicationService
    attr_reader :params, :slack_client

    def initialize(params, slack_client)
      super()
      @params = params
      @slack_client = slack_client
    end

    def call
      ActiveRecord::Base.transaction do
        find_user
        response = create_slack_channel
        update_channel_description(response[:channel][:id])
        add_user_to_channel(response[:channel][:id])
        create_incident(response[:channel][:id])
      end
    end

    private

    def find_user
      @user = User.find_by(slack_user_id: params[:slack_user_id])
    end

    def create_slack_channel
      Slack::CreateChannel.call(params[:incident][:title], params[:team_id], slack_client)
    end

    def update_channel_description(channel_id)
      return unless params[:incident][:description].present?

      Slack::SetChannelDescription.call(channel_id, params[:incident][:description], slack_client)
    end

    def add_user_to_channel(channel_id)
      Slack::AddUserToChannel.call(params[:slack_user_id], channel_id, slack_client)
    end

    def create_incident(channel_id)
      params[:incident][:channel_id] = channel_id
      @user.incidents.create!(params[:incident])
    end
  end
end
