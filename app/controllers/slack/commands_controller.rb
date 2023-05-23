module Slack
  class CommandsController < BaseController
    def create
      command = params[:text].split.first
      set_slack_client

      case command
      when 'declare'
        handle_declare_command
      when 'resolve'
        handle_resolve_command
      else
        handle_unknown_command
      end
    end

    private

    def set_slack_client
      @slack_client = Slack::Web::Client.new(token: retrieve_access_token)
    end

    def retrieve_access_token
      User.find_by(slack_user_id: params[:user_id]).access_token
    end

    def handle_declare_command
      title = params[:text].split[1..].join(' ')
      Slack::DisplayCreateIncidentModal.call(params[:trigger_id], title, @slack_client)
      head :ok
    end

    def handle_resolve_command
      incident = Incident.find_by(channel_id: params[:channel_id])

      if incident.blank?
        render json: { text: 'This command will not work in this channel' }
      elsif incident.resolved?
        render json: { text: 'This incident has already been resolved' }
      else
        DisplayResolveIncidentModal.call(params[:trigger_id], params[:channel_id], @slack_client)
      end
    end

    def handle_unknown_command
      render plain: 'Unknown command'
    end
  end
end
