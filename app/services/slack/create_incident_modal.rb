module Slack
  class CreateIncidentModal < ApplicationService
    def initialize(trigger_id, title)
      @trigger_id = trigger_id
      @title = title
    end

    def call
      client = Slack::Web::Client.new

      # Define the blocks for the modal
      blocks = [
        {
          type: 'input',
          block_id: 'title',
          element: {
            type: 'plain_text_input',
            action_id: 'title',
            initial_value: @title,
            placeholder: {
              type: 'plain_text',
              text: 'What is the title of the incident?'
            }
          },
          label: {
            type: 'plain_text',
            text: 'Title'
          }
        },
        {
          type: 'input',
          optional: true,
          block_id: 'description',
          element: {
            type: 'plain_text_input',
            action_id: 'description',
            placeholder: {
              type: 'plain_text',
              text: 'Write a brief description about what happened'
            }
          },
          label: {
            type: 'plain_text',
            text: 'Description'
          }
        },
        {
          type: 'input',
          optional: true,
          block_id: 'severity',
          element: {
            type: 'static_select',
            action_id: 'severity',
            options: [
              {
                text: {
                  type: 'plain_text',
                  text: 'sev0'
                },
                value: 'sev0'
              },
              {
                text: {
                  type: 'plain_text',
                  text: 'sev1'
                },
                value: 'sev1'
              },
              {
                text: {
                  type: 'plain_text',
                  text: 'sev2'
                },
                value: 'sev2'
              }
            ],
            placeholder: {
              type: 'plain_text',
              text: 'Select a severity level'
            }
          },
          label: {
            type: 'plain_text',
            text: 'Severity'
          }
        }
      ]

      # Define the modal view
      view = {
        type: 'modal',
        title: {
          type: 'plain_text',
          text: 'Create an Incident'
        },
        submit: {
          type: 'plain_text',
          text: 'Create'
        },
        close: {
          type: 'plain_text',
          text: 'Cancel'
        },
        callback_id: 'create_incident_modal',
        blocks: blocks
      }

      # Open the modal
      client.views_open(
        trigger_id: @trigger_id,
        view: view.to_json
      )
    end
  end
end

