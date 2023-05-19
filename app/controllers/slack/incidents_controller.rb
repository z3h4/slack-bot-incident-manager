module Slack
  class IncidentsController < BaseController
    skip_before_action :verify_slack_request, only: [:index]

    def index
      sort_column = determine_sort_column(params[:sort_column])
      sort_direction = determine_sort_direction(params[:sort_direction])

      incidents = fetch_incidents(sort_column, sort_direction)
      @incidents = build_incident_data(incidents)
      sort_incidents!(sort_column, sort_direction)
    end

    def create
      payload = JSON.parse(params[:payload], symbolize_names: true)
      return unless payload[:type] == 'view_submission'

      case payload.dig(:view, :callback_id)
      when 'create_incident_modal'
        create_incident(payload)
      when 'resolve_incident_modal'
        resolve_incident(payload)
      end
    end

    private

    def incident_params(slack_modal_data)
      title = slack_modal_data.dig(:title, :title, :value)
      description = slack_modal_data.dig(:description, :description, :value)
      severity = slack_modal_data.dig(:severity, :severity, :selected_option, :value)
      { title:, description:, severity: }
    end

    def create_incident(payload)
      @data = extract_data_from_payload(payload)
      create_new_incident(@data)
    rescue IncidentManager::Error => e
      handle_create_incident_error(e)
    end

    def resolve_incident(payload)
      private_metadata = JSON.parse(payload.dig(:view, :private_metadata), symbolize_names: true)
      Slack::ResolveIncident.call(private_metadata[:channel_id])
      head :ok
    end

    def handle_create_incident_error(error)
      if error.cause.instance_of?(Slack::Web::Api::Errors::NameTaken)
        render json: name_taken_error_payload
      else
        Rails.logger.error("Error creating channel: #{error.message}")
      end
    end

    def extract_data_from_payload(payload)
      incident_data = incident_params(payload.dig(:view, :state, :values))
      user_data = { id: payload.dig(:user, :id), name: payload.dig(:user, :name) }
      team_id = payload[:team][:id]

      { incident: incident_data, user: user_data, team_id: }
    end

    def create_new_incident(data)
      Slack::CreateIncident.call(data)
      render json: incident_created_modal_payload
    end

    def determine_sort_column(sort_column)
      allowed_columns = %w[title description severity resolved_at reporter status]
      allowed_columns.include?(sort_column) ? sort_column : 'title'
    end

    def determine_sort_direction(sort_direction)
      %w[asc desc].include?(sort_direction) ? sort_direction : 'asc'
    end

    def fetch_incidents(sort_column, sort_direction)
      if %w[reporter status].include?(sort_column)
        Incident.includes(:reporter)
      else
        Incident.includes(:reporter).order(Arel.sql("#{sort_column} #{sort_direction}"))
      end
    end

    def build_incident_data(incidents)
      incidents.map do |incident|
        resolved_at = incident.resolved_at&.strftime('%B %d, %Y %I:%M:%S %p') || ''
        incident.attributes
                .slice('title', 'description', 'severity')
                .merge(
                  'resolved_at' => resolved_at,
                  'reporter' => incident.reporter.name,
                  'status' => incident.status
                )
      end
    end

    def sort_incidents!(sort_column, sort_direction)
      return unless %w[reporter status].include?(sort_column)

      case sort_column
      when 'reporter'
        @incidents.sort_by! { |incident| incident['reporter'] }
      when 'status'
        @incidents.sort_by! { |incident| incident['status'] }
      end

      @incidents.reverse! if sort_direction == 'desc'
    end

    def name_taken_error_payload
      {
        response_action: 'errors',
        errors: {
          title: 'This title is not available. Please enter a new one.'
        }
      }
    end

    def incident_created_modal_payload
      {
        response_action: 'update',
        view: {
          type: 'modal',
          title: {
            type: 'plain_text',
            text: 'Incident created'
          },
          blocks: [
            {
              type: 'section',
              text: {
                type: 'plain_text',
                text: "New incident #{@data[:incident][:title]} created"
              }
            }
          ]
        }
      }
    end
  end
end
