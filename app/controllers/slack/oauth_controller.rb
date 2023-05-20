module Slack
  class OauthController < ApplicationController
    REDIRECT_URI = 'https://324a-2604-3d09-d08b-8f00-1dcb-691d-d5a9-e69e.ngrok-free.app/oauth/callback'.freeze
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
        redirect_uri: CGI.escape(REDIRECT_URI)
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
