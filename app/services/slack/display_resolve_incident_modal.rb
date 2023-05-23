module Slack
  class DisplayResolveIncidentModal < ApplicationService
    attr_reader :trigger_id, :channel_id, :slack_client

    def initialize(trigger_id, channel_id, slack_client)
      super()
      @trigger_id = trigger_id
      @channel_id = channel_id
      @slack_client = slack_client
    end

    def call
      # Open the modal
      slack_client.views_open(
        trigger_id:,
        view: view_payload
      )
    end

    private

    def private_metadata
      { channel_id: }
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
              text: 'Would you like to resolve this incident?'
            }
          }
        ],
        private_metadata: JSON.dump(private_metadata)
      }
    end
  end
end
