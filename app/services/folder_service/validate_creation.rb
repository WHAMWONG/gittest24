module FolderService
  class ValidateCreation
    def self.validate_folder_creation(user_id:, folder_name:)
      existing_folder = Folder.find_by(user_id: user_id, name: folder_name)
      if existing_folder
        error_message = I18n.t('activerecord.errors.messages.taken')
        { is_valid: false, error_message: error_message }
      else
        { is_valid: true, error_message: nil }
      end
    end
  end
end
