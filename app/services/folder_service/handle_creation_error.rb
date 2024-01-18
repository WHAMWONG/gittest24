module FolderService
  class HandleCreationError
    def initialize(user_id, error_message)
      @user_id = user_id
      @error_message = error_message
    end

    def call
      Rails.logger.error "User ID: #{@user_id}, Error: #{@error_message}"

      user = User.find_by(id: @user_id)
      unless user
        return { status: 'Error', error_message: 'User not found' }
      end

      if @error_message.include?('validation')
        guidance_message = I18n.t('activerecord.errors.messages.correct_the_issue')
        { status: 'Error', error_message: "#{@error_message}. #{guidance_message}" }
      else
        { status: 'Error', error_message: @error_message }
      end
    end
  end
end
