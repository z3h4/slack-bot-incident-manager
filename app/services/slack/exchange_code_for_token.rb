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
                     code: code
                   })
    end

    private

    def post_request(url, params)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.path)
      request.body = params.to_json
      request['Content-Type'] = 'application/json'

      response = http.request(request)
      JSON.parse(response.body)
    end

  end
end
