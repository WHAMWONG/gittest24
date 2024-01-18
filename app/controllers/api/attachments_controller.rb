class Api::AttachmentsController < ApplicationController
  before_action :authorize_attachment, only: [:create]

  def create
    service = TodoService::AttachFile.new(
      todo_id: params[:todo_id],
      file_path: params[:file].tempfile.path,
      file_name: params[:file].original_filename
    )

    result = service.call

    if result[:id]
      render json: { message: result[:message], attachment_id: result[:id] }, status: :created
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  private

  def authorize_attachment
    # Implement authorization logic here, possibly using AttachmentPolicy
  end
end
