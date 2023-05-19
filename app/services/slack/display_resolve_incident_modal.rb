module Slack
  class DisplayResolveIncidentModal < ApplicationService
    def initialize(trigger_id, channel_id)
      @trigger_id = trigger_id
      @channel_id = channel_id
    end

    def call
      # Open the modal
      slack_client.views_open(
        trigger_id: @trigger_id,
        view: view_payload
      )
    end

    private

    def private_metadata
      { channel_id: @channel_id }
    end

    def view_payload
      {
        type: 'modal',
        title: {
          type: 'plain_text',
          text: 'Resolve Incident'
        },
        submit: {
          type: 'plain_text',
          text: 'Confirm'
        },
        close: {
          type: 'plain_text',
          text: 'Cancel'
        },
        callback_id: 'resolve_incident_modal',
        blocks: [
          {
            type: 'section',
            text: {
              type: 'plain_text',
              text: 'Would you like to resolve this incident?',
            }
          }
        ],
        private_metadata: JSON.dump(private_metadata)
      }
    end
  end
end
