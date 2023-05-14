module Slack
  class IncidentsController < BaseController
    def create
      payload = JSON.parse(params[:payload])
      if payload['type'] == 'view_submission'
        # Create an Incident in the database
        head :ok
      end
    end
  end
end
