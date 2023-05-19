module Persistence
  class CreateIncident < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        find_or_create_user
        response = Slack::CreateChannel.call(@params[:incident][:title], @params[:team_id])
        Slack::SetChannelDescription.call(response[:channel][:id], @params[:incident][:description])
        Slack::AddUserToChannel.call(@params[:user][:id], response[:channel][:id])
        create_incident(response[:channel][:id])
      end
    end

    private

    def find_or_create_user
      @user = Reporter.create_with(name: @params[:user][:name]).find_or_create_by(slack_user_id: @params[:user][:id])
    end

    def create_incident(channel_id)
      @params[:incident][:channel_id] = channel_id
      @user.incidents.create!(incident_params)
    end

    def incident_params
      @params.require(:incident).permit(:title, :description, :severity, :channel_id)
    end
  end
end
