module Slack
  class GetUserInformation < ApplicationService
    attr_reader :slack_user_id, :access_token

    def initialize(slack_user_id, access_token)
      @slack_user_id = slack_user_id
      @access_token = access_token
    end

    def call
      response = slack_client(access_token).users_info(user: slack_user_id)
      response[:user]
    end
  end
end
