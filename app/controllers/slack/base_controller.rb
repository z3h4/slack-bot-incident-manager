module Slack
  class BaseController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :verify_slack_request

    private

    def verify_slack_request
      timestamp = request.headers['X-Slack-Request-Timestamp']
      if (Time.now.to_i - timestamp.to_i).abs > 5.minutes.to_i
        head :unauthorized
        return
      end

      version = 'v0'
      sig_basestring = [version, timestamp, request.raw_post].join(':')
      hex_hash = OpenSSL::HMAC.hexdigest("SHA256", Rails.application.credentials.dig(:slack, :signing_secret), sig_basestring)
      my_signature = [version, hex_hash].join('=')
      slack_signature = request.headers['X-Slack-Signature']

      unless ActiveSupport::SecurityUtils.secure_compare(my_signature, slack_signature)
        head :unauthorized
      end
    end
  end
end
