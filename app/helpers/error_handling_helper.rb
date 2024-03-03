# frozen_string_literal: true

module ErrorHandlingHelper
  def handle_error_and_redirect(redirect_path, error_message)
    yield
  rescue StandardError => e
    flash[:error] = error_message
    redirect_to redirect_path
  end
end
