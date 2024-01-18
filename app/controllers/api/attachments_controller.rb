class Api::AttachmentsController < ApplicationController
  before_action :authorize_attachment, only: [:create]

  # The create method has been removed as it is not needed.
  def create
    service = TodoService::AttachFile.new(
      todo_id: params[:todo_id],
      file_path: params[:file_path],
      file_name: params[:file_name]
    )
    result = service.call

    if result[:error].present?
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render :create, status: :created, locals: { attachment: result }
    end
  end

  private

  def authorize_attachment
    # Implement authorization logic here, possibly using AttachmentPolicy
  end
end

end
