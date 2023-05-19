require 'incident_manager/errors'
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def slack_client
    @slack_client ||= Slack::Web::Client.new
  end
end
