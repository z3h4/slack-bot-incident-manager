module Slack
  class CreateIncident < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        find_or_create_user
        response = create_slack_channel
        update_channel_description(response[:channel][:id])
        add_user_to_channel(response[:channel][:id])
        create_incident(response[:channel][:id])
      end
    end

    private

    def find_or_create_user
      @user = Reporter.create_with(name: @params[:user][:name])
                      .find_or_create_by(slack_user_id: @params[:user][:id])
    end

    def create_slack_channel
      Slack::CreateChannel.call(@params[:incident][:title], @params[:team_id])
    end

    def update_channel_description(channel_id)
      return unless @params[:incident][:description].present?

      Slack::SetChannelDescription.call(channel_id, @params[:incident][:description])
    end

    def add_user_to_channel(channel_id)
      Slack::AddUserToChannel.call(@params[:user][:id], channel_id)
    end

    def create_incident(channel_id)
      @params[:incident][:channel_id] = channel_id
      @user.incidents.create!(@params[:incident])
    end
  end
end
