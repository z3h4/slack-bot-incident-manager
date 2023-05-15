class Incident < ApplicationRecord
  SEVERITY = %w[sev0 sev1 sev2].freeze

  belongs_to :reporter

  validates :title, presence: true, length: { maximum: 80 }
  validates :channel_id, presence: true
  validates :severity, inclusion: { in: SEVERITY, allow_nil: true }

  scope :open, -> { where(resolved_at: nil) }
  scope :resolved, -> { where.not(id: open) }

  def resolve!
    update!(resolved_at: DateTime.current)
  end
end
