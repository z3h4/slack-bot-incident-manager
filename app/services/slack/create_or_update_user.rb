module Slack
  class CreateOrUpdateUser < ApplicationService
    attr_reader :slack_user_id, :access_token

    def initialize(slack_user_id, access_token)
      super()
      @slack_user_id = slack_user_id
      @access_token = access_token
    end

    def call
      user = find_user
      if user.present?
        update_user_access_token(user)
      else
        ActiveRecord::Base.transaction do
          team = create_team(user_info[:team_id])
          create_user(user_info, team)
        end
      end
    end

    private

    def find_user
      User.find_by(slack_user_id:)
    end

    def update_user_access_token(user)
      user.update!(access_token:)
    end

    def user_info
      GetUserInformation.call(slack_user_id, access_token)
    end

    def create_user(user_info, team)
      team.users
          .create_with(name: user_info[:real_name], access_token:)
          .find_or_create_by(slack_user_id: user_info[:id])
    end

    def create_team(slack_team_id)
      Team.find_or_create_by!(slack_team_id:)
    end
  end
end
