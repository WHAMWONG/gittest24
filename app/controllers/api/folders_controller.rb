module Api
  class FoldersController < BaseController
    include FolderService
    include Pundit::Authorization

    before_action :doorkeeper_authorize!

    def validate
      authorize Folder, policy_class: FolderPolicy

      folder_name = params[:name]
      if folder_name.blank?
        render json: { error: "The folder name is required." }, status: :bad_request
        return
      end

      validation_result = FolderService::ValidateCreation.validate_folder_creation(
        user_id: current_user.id,
        folder_name: folder_name
      )

      if validation_result[:is_valid]
        render json: { status: 200, message: "The folder name is valid and unique." }, status: :ok
      else
        render json: { error: validation_result[:error_message] }, status: :conflict
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def handle_folder_creation_error
      error_message = params[:error_message]

      if error_message.blank?
        render json: { message: "An error message is required." }, status: :bad_request
        return
      end

      result = HandleCreationError.new(current_resource_owner.id, error_message).call

      case result[:status]
      when 'Error'
        if result[:error_message].include?('User not found')
          render json: { message: result[:error_message] }, status: :unauthorized
        else
          render json: { message: result[:error_message] }, status: :internal_server_error
        end
      else
        render json: { status: 200, message: "The error has been handled: #{error_message}" }, status: :ok
      end
    end

    private

    def folder_params
      params.require(:folder).permit(:name)
    end
  end
end
