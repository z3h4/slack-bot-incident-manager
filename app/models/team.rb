class Team < ApplicationRecord
  has_many :users
  has_many :incidents

  validates :slack_team_id, presence: true
end
