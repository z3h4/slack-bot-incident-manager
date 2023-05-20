Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post '/slack/command', to: 'slack/commands#create'
  post '/slack/incidents', to: 'slack/incidents#create'
  get '/oauth/callback', to: 'slack/oauth#callback'

  # Defines the root path route ("/")
  scope module: 'slack' do
    root 'incidents#index'
  end
end
