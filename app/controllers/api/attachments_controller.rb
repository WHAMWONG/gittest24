class Api::AttachmentsController < ApplicationController
  before_action :authorize_attachment, only: [:create]

  # The create method has been removed as it is not needed.
  # Corresponding route will also be removed from /config/routes.rb

  private

  def authorize_attachment
    # Implement authorization logic here, possibly using AttachmentPolicy
  end
end

end
