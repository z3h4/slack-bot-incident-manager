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
        create_user(user_info)
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

    def create_user(user_info)
      User.create!(
        name: user_info[:real_name],
        slack_user_id: user_info[:id],
        team_id: user_info[:team_id],
        access_token:
      )
    end
  end
end
