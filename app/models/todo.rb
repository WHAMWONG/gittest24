
class Todo < ApplicationRecord
  has_many :attachments, dependent: :destroy

  belongs_to :user

  enum priority: %w[low medium high], _suffix: true
  enum recurrence: %w[daily weekly monthly], _suffix: true

  # validations
  validates :title, presence: true, length: { maximum: 255 }

  validate :validate_due_date

  # end for validations

  private

  def validate_due_date
    errors.add(:due_date, :datetime_in_past) if due_date.present? && due_date < Time.zone.now
    errors.add(:due_date, :invalid) unless due_date.is_a?(DateTime)
  end

  class << self
  end
end
