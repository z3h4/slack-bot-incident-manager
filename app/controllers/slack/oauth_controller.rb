module Slack
  class OauthController < ApplicationController
    include HTTParty

    SCOPES = 'chat:write commands groups:write'.freeze

    def authorize
      redirect_to slack_authorization_url
    end

    def callback
      if params[:code]
        response = Slack::ExchangeCodeForToken.call(slack_credentials, params[:code])
        access_token = response['access_token']
        store_access_token(access_token)
        redirect_to root_path, notice: 'Slack app installed successfully!'
      else
        redirect_to root_path, alert: 'Failed to install the Slack app.'
      end
    end

    private

    def slack_authorization_url
      query_params = {
        client_id: Rails.application.credentials.dig(:slack, :client_id),
        scope: SCOPES,
        redirect_uri: "https://#{Rails.application.config.oauth_redirect_uri_host}/oauth/callback"
      }

      "https://slack.com/oauth/v2/authorize?#{query_params.to_query}"
    end

    def slack_credentials
      Rails.application.credentials[:slack]
    end

    def store_access_token(access_token)
      session[:access_token] = access_token
    end
  end
end
