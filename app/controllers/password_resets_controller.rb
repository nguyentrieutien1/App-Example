# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :load_user_by_reset_digest, :valid_user, :check_expiration, only: %i(edit update)
  before_action :load_user_by_name, only: :create

  def new; end

  def edit; end

  def create
    if @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "email.password_reset.subject"
      redirect_to root_path
    else
      flash[:danger] = t "server.error_message"
      redirect_to root_path
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "update.user.success_message", name: t("update.user.label_name")
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "email.expired_time"
    redirect_to new_password_reset_url
  end

  def load_user_by_name
    load_user_by_field(:name, params[:name], t("not_found.user"))

  end

  def load_user_by_reset_digest
    load_user_by_field(:reset_digest, params[:id], t("email.activation.invalid_link"))
  end

  def load_user_by_field(field, value, flash_message)
    @user = User.find_by(field => value)
    return if @user

    flash.now[:danger] = flash_message
    render :new, status: :unprocessable_entity
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "email.activation.deactivated"
  end
end
