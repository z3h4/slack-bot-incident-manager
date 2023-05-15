module Slack
  class IncidentsController < BaseController
    def create
      payload = JSON.parse(params[:payload], symbolize_names: true)
      return unless payload[:type] == 'view_submission'

      params[:incident] = incident_params(payload.dig(:view, :state, :values))
      params[:user] = { id: payload.dig(:user, :id), name: payload.dig(:user, :name) }
      params[:team_id] = payload[:team][:id]

      begin
        Persistence::CreateIncident.call(params)
        head :ok
      rescue IncidentManager::Error => e
        if e.cause.instance_of?(Slack::Web::Api::Errors::NameTaken)
          render json: name_taken_error_payload
        else
          Rails.logger.error("Error creating channel: #{e.message}")
          #TODO: Maybe push a new view to show the other types of error
        end
      end
    end

    private

    def incident_params(slack_modal_data)
      title = slack_modal_data.dig(:title, :title, :value)
      description = slack_modal_data.dig(:description, :description, :value)
      severity = slack_modal_data.dig(:severity, :severity, :selected_option, :value)
      { title:, description:, severity: }
    end

    def name_taken_error_payload
      {
        response_action: 'errors',
        errors: {
          title: 'This title is not available. Please enter a new one.'
        }
      }
    end
  end
end
