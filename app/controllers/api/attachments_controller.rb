
class Api::AttachmentsController < ApplicationController
  before_action :authorize_attachment, only: [:create]

  def create
    service = TodoService::AttachFile.new(
      todo_id: params[:todo_id],
      file_path: params[:file_path],
      file_name: params[:file_name]
    )
    result = service.call

    if result[:error].blank?
      render :create, status: :created, locals: { attachment: result }
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  private
  def authorize_attachment
    # Implement authorization logic here, possibly using AttachmentPolicy
  end

end
