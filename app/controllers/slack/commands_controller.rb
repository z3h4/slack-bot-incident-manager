module Slack
  class CommandsController < BaseController
    def create
      command = params[:text].split.first

      case command
      when 'declare'
        title = params[:text].split[1..].join(' ')
        Slack::DisplayCreateIncidentModal.call(params[:trigger_id], title)
        head :ok
      when 'resolve'
        incident = Incident.find_by(channel_id: params[:channel_id])
        if incident.blank?
          render json: { text: 'This command will not work in this channel' }
          return
        elsif incident.resolved?
          render json: { text: 'This incident has already been resolved' }
          return
        end

        DisplayResolveIncidentModal.call(params[:trigger_id], params[:channel_id])
      else
        # TODO: Maybe better to return a HTTP code?
        render plain: 'Unknown command'
      end
    end
  end
end
