module FolderService
  class Create < BaseService
    def call(user_id:, name:, color: nil, icon: nil)
      user = User.find_by(id: user_id)
      return { error: I18n.t('activerecord.errors.messages.invalid') } unless user

      if user.folders.exists?(name: name)
        return { error: I18n.t('activerecord.errors.messages.taken') }
      end

      folder = user.folders.build(name: name, color: color, icon: icon)
      folder.created_at = Time.current
      folder.updated_at = Time.current

      if folder.save
        {
          folder_id: folder.id,
          name: folder.name,
          color: folder.color,
          icon: folder.icon,
          created_at: folder.created_at,
          updated_at: folder.updated_at
        }
      else
        { error: folder.errors.full_messages.to_sentence }
      end
    rescue ActiveRecord::RecordNotFound
      { error: I18n.t('activerecord.errors.messages.invalid') }
    end
  end
end
