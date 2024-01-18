
class Attachment < ApplicationRecord
  belongs_to :todo

  # validations
  validates :file_path, presence: { message: I18n.t('activerecord.errors.messages.blank') }
  validates :file_name, presence: { message: I18n.t('activerecord.errors.messages.blank') }
  # Add custom validations for storage system's requirements if needed
  # end for validations

  class << self
  end
end
