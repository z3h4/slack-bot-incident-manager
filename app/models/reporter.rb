class Reporter < ApplicationRecord
  has_many :incidents

  validates :name, presence: true
end
