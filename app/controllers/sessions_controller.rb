# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new
    @user = User.new
  end

  def create
    if @user.authenticate params[:password]
      reset_session
      log_in @user
      redirect_to @user, status: :see_other
    else
      handle_failed_login
    end
  end

  def destroy
    log_out
    redirect_to root_path, status: :see_other
  end

  private

  def load_user
    @user = User.find_by(name: params[:name]&.downcase)
    return @user if @user
    handle_failed_login
  end

  def handle_failed_login
    flash.now[:danger] = t "sessions.create.error_login_message"
    render :new, status: :unprocessable_entity
  end
end
