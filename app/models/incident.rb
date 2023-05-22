class Incident < ApplicationRecord
  SEVERITY = %w[sev0 sev1 sev2].freeze

  belongs_to :user

  validates :title, presence: true, length: { maximum: 80 }
  validates :channel_id, presence: true
  validates :severity, inclusion: { in: SEVERITY, allow_nil: true }

  def resolve!
    update!(resolved_at: DateTime.current)
  end

  def status
    resolved_at? ? 'Resolved' : 'Open'
  end

  def resolved?
    resolved_at.present?
  end
end
