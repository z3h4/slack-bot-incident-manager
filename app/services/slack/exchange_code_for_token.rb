module Slack
  class ExchangeCodeForToken < ApplicationService
    attr_reader :credentials, :code

    def initialize(credentials, code)
      @credentials = credentials
      @code = code
    end

    def call
      post_request('https://slack.com/api/oauth.v2.access', {
                     client_id: credentials[:client_id],
                     client_secret: credentials[:client_secret],
                     code:
                   })
    end

    private

    def post_request(url, params)
      response = HTTParty.post(url, body: params)
      JSON.parse(response.body)
    end

  end
end
