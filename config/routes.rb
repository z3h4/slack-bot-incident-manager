Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post '/slack/command', to: 'slack/commands#create'
  post '/slack/incidents', to: 'slack/incidents#create'

  # Defines the root path route ("/")
  # root "articles#index"
end
