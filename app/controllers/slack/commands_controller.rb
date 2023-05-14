module Slack
  class CommandsController < BaseController
    def create
      command = params[:text].split.first

      case command
      when 'declare'
        title = params[:text].split[1..].join(' ')
        Slack::CreateIncidentModal.call(params[:trigger_id], title)
        head :ok
      when 'resolve'
        render json: { text: 'Resolve' }
      else
        # TODO: Maybe better to return a HTTP code?
        render plain: 'Unknown command'
      end
    end
  end
end
