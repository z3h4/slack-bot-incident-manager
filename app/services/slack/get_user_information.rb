module Slack
  class GetUserInformation < ApplicationService
    attr_reader :slack_user_id, :access_token

    def initialize(slack_user_id, access_token)
      super()
      @slack_user_id = slack_user_id
      @access_token = access_token
    end

    def call
      response = slack_client.users_info(user: slack_user_id)
      response[:user]
    end

    private

    def slack_client
      Slack::Web::Client.new(token: access_token)
    end
  end
end
