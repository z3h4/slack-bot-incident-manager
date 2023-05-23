class User < ApplicationRecord
  has_many :incidents
  belongs_to :team

  validates :name, presence: true
  validates :slack_user_id, presence: true
  validates :team_id, presence: true
  validates :access_token, presence: true
end
