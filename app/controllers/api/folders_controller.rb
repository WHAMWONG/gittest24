module Api
  class FoldersController < BaseController
    before_action :doorkeeper_authorize!

    def create
      authorize :folder, policy_class: FolderPolicy

      validation = FolderService::ValidateCreation.validate_folder_creation(
        user_id: current_resource_owner.id,
        folder_name: folder_params[:name]
      )

      if validation[:is_valid]
        result = FolderService::Create.new.call(
          user_id: current_resource_owner.id,
          name: folder_params[:name],
          color: folder_params[:color],
          icon: folder_params[:icon]
        )

        if result[:folder_id]
          render json: result, status: :created
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      else
        render json: { error: validation[:error_message] }, status: :conflict
      end
    end

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

    def cancel_creation
      authorize :folder, policy_class: FolderPolicy

      # Business logic to cancel folder creation would go here
      # Since no specific logic is required, we simply return a success message

      render json: { status: 200, message: "Folder creation process has been canceled successfully." }, status: :ok
    end

    private

    def folder_params
      params.permit(:name, :color, :icon)
    end

    def current_resource_owner
      current_user || super
    end
  end
end
