# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception
  include SessionsHelper
  include Pagy::Backend

  def switch_language
    locale = params[:locale]
    session[:locale] = locale
    redirect_back(fallback_location: root_path)
  end

  private

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "auth.missing_login_message"
    redirect_to sessions_new_path
  end
end
