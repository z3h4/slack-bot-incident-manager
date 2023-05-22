require 'incident_manager/errors'
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def slack_client(access_token)
    @slack_client = Slack::Web::Client.new(token: access_token)
  end
end
